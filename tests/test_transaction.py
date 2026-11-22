import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
import sm_transaction as T


class TransactionTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.a, self.b = self.root / 'a', self.root / 'b'
        self.a.write_bytes(b'old-a')

    def test_commit_existing_and_new(self):
        T.commit_files(self.root, {self.a: b'new-a', self.b: b'new-b'})
        self.assertEqual(self.a.read_bytes(), b'new-a')
        self.assertEqual(self.b.read_bytes(), b'new-b')
        self.assertEqual(T.recover(self.root), 'none')

    def test_failure_rolls_back_all_files(self):
        original = T._replace_bytes
        def fail(path, data):
            if path == self.b and data == b'new-b':
                raise OSError('injected failure')
            return original(path, data)
        with patch.object(T, '_replace_bytes', side_effect=fail):
            with self.assertRaises(OSError):
                T.commit_files(self.root, {self.a: b'new-a', self.b: b'new-b'})
        self.assertEqual(self.a.read_bytes(), b'old-a')
        self.assertFalse(self.b.exists())
        T.assert_ready(self.root)

    def test_interruption_requires_explicit_recovery(self):
        original = T._replace_bytes
        def crash(path, data):
            if path == self.b:
                raise SystemExit('simulated process interruption')
            return original(path, data)
        with patch.object(T, '_replace_bytes', side_effect=crash):
            with self.assertRaises(SystemExit):
                T.commit_files(self.root, {self.a: b'new-a', self.b: b'new-b'})
        self.assertEqual(self.a.read_bytes(), b'new-a')
        with self.assertRaises(T.RecoveryRequired):
            T.assert_ready(self.root)
        with self.assertRaises(T.RecoveryRequired):
            T.commit_files(self.root, {self.a: b'other'})
        self.assertEqual(T.recover(self.root), 'rolled-back')
        self.assertEqual(self.a.read_bytes(), b'old-a')
        self.assertFalse(self.b.exists())
        self.assertEqual(T.recover(self.root), 'none')

    def test_rollback_failure_retains_backups(self):
        original = T._replace_bytes
        def fail(path, data):
            if path == self.b or (path == self.a and data == b'old-a'):
                raise OSError('failure')
            return original(path, data)
        with patch.object(T, '_replace_bytes', side_effect=fail):
            with self.assertRaises(T.RecoveryRequired):
                T.commit_files(self.root, {self.a: b'new-a', self.b: b'new-b'})
        self.assertTrue((self.root / T.TRANSACTION / 'journal.json').exists())
        self.assertEqual(T.recover(self.root), 'rolled-back')
        self.assertEqual(self.a.read_bytes(), b'old-a')

    def test_recovery_interruption_is_retryable_and_removes_created_files(self):
        original = T._replace_bytes
        c = self.root / 'c'
        def crash_commit(path, data):
            if path == c:
                raise SystemExit()
            return original(path, data)
        with patch.object(T, '_replace_bytes', side_effect=crash_commit):
            with self.assertRaises(SystemExit):
                T.commit_files(self.root, {self.a: b'new-a', self.b: b'new-b', c: b'new-c'})
        self.assertTrue(self.b.exists())
        def crash_recovery(path, data):
            if path == self.a:
                raise SystemExit()
            return original(path, data)
        with patch.object(T, '_replace_bytes', side_effect=crash_recovery):
            with self.assertRaises(SystemExit):
                T.recover(self.root)
        self.assertFalse(self.b.exists())
        self.assertEqual(T.recover(self.root), 'rolled-back')
        self.assertEqual(self.a.read_bytes(), b'old-a')

    def test_recovery_cleanup_interruption_keeps_finalized_journal(self):
        original = T._replace_bytes
        def crash(path, data):
            if path == self.b:
                raise SystemExit()
            return original(path, data)
        with patch.object(T, '_replace_bytes', side_effect=crash):
            with self.assertRaises(SystemExit):
                T.commit_files(self.root, {self.a: b'new-a', self.b: b'new-b'})
        with patch.object(T, '_cleanup', side_effect=SystemExit):
            with self.assertRaises(SystemExit):
                T.recover(self.root)
        # A finalized journal no longer needs backups when cleanup is retried.
        (self.root / T.TRANSACTION / 'old-0').unlink()
        self.assertEqual(T.recover(self.root), 'rolled-back')
        self.assertEqual(self.a.read_bytes(), b'old-a')

    def test_committed_cleanup_interruption_does_not_undo_success(self):
        with patch.object(T, '_cleanup', side_effect=SystemExit):
            with self.assertRaises(SystemExit):
                T.commit_files(self.root, {self.a: b'new-a'})
        self.assertEqual(T.recover(self.root), 'committed')
        self.assertEqual(self.a.read_bytes(), b'new-a')

    def test_escape_and_relative_targets_rejected(self):
        for target in (self.root.parent / 'outside', Path('relative')):
            with self.assertRaises(ValueError):
                T.commit_files(self.root, {target: b'bad'})
        self.assertEqual(self.a.read_bytes(), b'old-a')

    def test_live_writer_blocks_recovery_and_another_commit(self):
        with T._locked(self.root):
            with self.assertRaises(OSError):
                T.commit_files(self.root, {self.a: b'bad'})
            with self.assertRaises(OSError):
                T.recover(self.root)


if __name__ == '__main__':
    unittest.main()
