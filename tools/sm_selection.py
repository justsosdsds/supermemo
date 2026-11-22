"""Select literal UTF-8 text in an HTML text node, preserving byte offsets.

Entities and selections spanning tags are deliberately unsupported here; a UI
adapter must map its DOM range before supporting those cases.
"""
import re

_MARKUP = re.compile(rb'<!--.*?-->|<[^>]*>|&(?:#\d+|#x[0-9a-f]+|[a-z][a-z0-9]*);', re.I | re.S)


def locate(body, keyword, occurrence=None, byte_offset=None):
    needle = keyword.encode('utf-8') if isinstance(keyword, str) else keyword
    if not needle or b'\0' in needle:
        raise ValueError('selection must be nonempty text without NUL')
    if occurrence is not None and byte_offset is not None:
        raise ValueError('choose occurrence OR byte offset')
    protected = [(m.start(), m.end()) for m in _MARKUP.finditer(body)]
    # Do not select executable/style text either.
    protected += [(m.start(), m.end()) for m in re.finditer(
        rb'<(script|style)\b[^>]*>.*?</\1\s*>', body, re.I | re.S)]
    matches, start = [], 0
    while True:
        pos = body.find(needle, start)
        if pos < 0:
            break
        if not any(pos < end and pos + len(needle) > begin for begin, end in protected):
            matches.append(pos)
        start = pos + len(needle)
    if byte_offset is not None:
        if byte_offset not in matches:
            raise ValueError('byte offset does not match selectable text')
        return byte_offset
    if occurrence is not None:
        if not 1 <= occurrence <= len(matches):
            raise ValueError('occurrence is outside the matching text range')
        return matches[occurrence - 1]
    if len(matches) != 1:
        raise ValueError('selection not found' if not matches else
                         'ambiguous selection; specify --occurrence or --byte-offset')
    return matches[0]
