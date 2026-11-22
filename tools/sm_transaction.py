"""Recoverable offline collection writes (not atomic visibility across files).

Close SuperMemo before use. The lock coordinates these Python writers only.
After a process interruption, call recover(collection) before reading/writing.
Backups are retained until all replacements and the committed journal are saved.
This handles process interruptions, not a guaranteed power-loss filesystem protocol.
"""
from contextlib import contextmanager
import json
import os
from pathlib import Path
import tempfile

TRANSACTION = '.sm-transaction'
LOCK = '.sm-write.lock'


class RecoveryRequired(RuntimeError):
    pass


@contextmanager
def _locked(root):
    with open(root / LOCK, 'a+b') as stream:
        stream.seek(0, 2)
        if not stream.tell():
            stream.write(b'\0')
            stream.flush()
        stream.seek(0)
        if os.name == 'nt':
            import msvcrt
            msvcrt.locking(stream.fileno(), msvcrt.LK_NBLCK, 1)
        else:
            import fcntl
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        try:
            yield
        finally:
            stream.seek(0)
            if os.name == 'nt':
                msvcrt.locking(stream.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                fcntl.flock(stream, fcntl.LOCK_UN)


def assert_ready(collection):
    """Reject a pending transaction; this is a check, not a read-session lock."""
    if (Path(collection).resolve() / TRANSACTION).exists():
        raise RecoveryRequired('Pending collection transaction; run recover(collection) first')


def _target(root, path):
    path = Path(path)
    if not path.is_absolute():
        raise ValueError('Transaction targets must be absolute paths')
    resolved = path.resolve()
    try:
        relative = resolved.relative_to(root)
    except ValueError:
        raise ValueError('Transaction target escapes collection') from None
    if not relative.parts or relative.parts[0] in (TRANSACTION, LOCK):
        raise ValueError('Invalid transaction target')
    if not resolved.parent.is_dir() or (resolved.exists() and not resolved.is_file()):
        raise ValueError('Target parent must exist and target must be a file')
    return resolved, relative.as_posix()


def _write(path, data):
    with open(path, 'wb') as stream:
        stream.write(data)
        stream.flush()
        os.fsync(stream.fileno())


def _replace_bytes(path, data):
    fd, name = tempfile.mkstemp(prefix='.sm-stage-', dir=path.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(name, path)
    finally:
        if os.path.exists(name):
            os.unlink(name)


def _journal(directory, manifest):
    _replace_bytes(directory / 'journal.json', json.dumps(manifest).encode('utf-8'))


def _cleanup(directory):
    # Do not recursively follow arbitrary entries in the recovery directory.
    for child in sorted(directory.iterdir(), key=lambda p: p.name == 'journal.json'):
        if not child.is_file() or child.is_symlink():
            raise RecoveryRequired('Unexpected entry in transaction directory')
        child.unlink()
    directory.rmdir()


def _restore(root, directory, manifest):
    # Validate every entry and load every backup before changing any target.
    operations = []
    for i, entry in enumerate(manifest['entries']):
        target, relative = _target(root, root / entry['path'])
        if relative != entry['path'] or type(entry['existed']) is not bool:
            raise RecoveryRequired('Invalid recovery journal')
        old = (directory / ('old-%d' % i)).read_bytes() if entry['existed'] else None
        operations.append((target, old))
    for target, old in reversed(operations):
        if old is None:
            target.unlink(missing_ok=True)
        else:
            _replace_bytes(target, old)


def commit_files(collection, mapping):
    """Save all supplied bytes, rolling back ordinary failures.

    A crash leaves a pending journal. Recovery is explicit and idempotent.
    Does not coordinate with SuperMemo or lock a caller's preceding reads.
    """
    root = Path(collection).resolve(strict=True)
    prepared, seen = [], set()
    for path, data in mapping.items():
        target, relative = _target(root, path)
        if target in seen:
            raise ValueError('Duplicate transaction target')
        seen.add(target)
        prepared.append((target, relative, bytes(data)))
    with _locked(root):
        assert_ready(root)
        if not prepared:
            return
        directory = root / TRANSACTION
        directory.mkdir()
        manifest = {'version': 1, 'state': 'prepared', 'entries': []}
        ready = False
        try:
            for i, (target, relative, data) in enumerate(prepared):
                existed = target.exists()
                if existed:
                    _write(directory / ('old-%d' % i), target.read_bytes())
                _write(directory / ('new-%d' % i), data)
                manifest['entries'].append({'path': relative, 'existed': existed})
            _journal(directory, manifest)
            ready = True
            for i, (target, _, _) in enumerate(prepared):
                _replace_bytes(target, (directory / ('new-%d' % i)).read_bytes())
            manifest['state'] = 'committed'
            _journal(directory, manifest)
        except Exception:
            try:
                if ready:
                    _restore(root, directory, manifest)
                    manifest['state'] = 'rolled-back'
                    _journal(directory, manifest)
                _cleanup(directory)
            except Exception as recovery_error:
                raise RecoveryRequired('Write failed and rollback is incomplete; recovery journal retained') from recovery_error
            raise
        _cleanup(directory)


def recover(collection):
    """Return 'none', 'rolled-back', 'committed', or 'discarded-staging'."""
    root = Path(collection).resolve(strict=True)
    with _locked(root):
        directory = root / TRANSACTION
        if not directory.exists():
            return 'none'
        if directory.is_symlink():
            raise RecoveryRequired('Invalid transaction directory')
        journal = directory / 'journal.json'
        if not journal.exists():
            _cleanup(directory)  # No target replacement starts before this file.
            return 'discarded-staging'
        manifest = json.loads(journal.read_text(encoding='utf-8'))
        if manifest.get('version') != 1 or manifest.get('state') not in ('prepared', 'committed', 'rolled-back'):
            raise RecoveryRequired('Unsupported recovery journal')
        outcome = manifest['state']
        if manifest['state'] == 'prepared':
            _restore(root, directory, manifest)
            outcome = 'rolled-back'
            manifest['state'] = outcome
            _journal(directory, manifest)
        _cleanup(directory)
        return outcome


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=['recover', 'check'])
    parser.add_argument('collection')
    args = parser.parse_args()
    if args.command == 'recover':
        print(recover(args.collection))
    else:
        assert_ready(args.collection)
        print('ready')
