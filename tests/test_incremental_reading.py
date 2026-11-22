import pathlib
import struct
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1] / 'tools'))
import smwrite as W
from sm_cloze import cloze as raw_cloze, mark_parent_body
from sm_extract import extract as raw_extract, wrap_selection
from sm_selection import locate


def cloze(*args, **kwargs):
    return raw_cloze(*args, experimental_registry=True, **kwargs)


def extract(*args, **kwargs):
    return raw_extract(*args, experimental_registry=True, **kwargs)


def snapshot(root):
    return {str(p.relative_to(root)): p.read_bytes()
            for p in root.rglob('*') if p.is_file()}


class SelectionTests(unittest.TestCase):
    def test_measured_extract_markup(self):
        body = b'AAA first paragraph</P>\r\n<P>BBB second paragraph</P>\r\n<P>CCC third paragraph'
        expected = (b'AAA first paragraph \r\n<P></P><SPAN class=extract>\r\n'
                    b'<P>BBB second paragraph</P>\r\n<P></SPAN>CCC third paragraph')
        self.assertEqual(wrap_selection(body, b'BBB second paragraph'), expected)

    def test_duplicate_requires_selection(self):
        body = b'<P>second first</P><P>second last</P>'
        with self.assertRaisesRegex(ValueError, 'ambiguous'):
            mark_parent_body(body, 'second')
        marked = mark_parent_body(body, 'second', occurrence=2)
        self.assertTrue(marked.startswith(b'<P>second first</P>'))
        self.assertIn(b'<P><SPAN class=cloze>[...]</SPAN> last', marked)

    def test_markup_is_not_selectable(self):
        body = b'<P title="word">word &amp;</P><script>word</script>'
        self.assertEqual(locate(body, 'word'), body.index(b'>word') + 1)
        for keyword in ('amp', 'title', ''):
            with self.assertRaises(ValueError):
                locate(body, keyword)

    def test_chinese_byte_offset(self):
        body = '<P>距离，距离</P>'.encode()
        pos = body.rfind('距离'.encode())
        result = mark_parent_body(body, '距离', byte_offset=pos)
        self.assertEqual(result.decode(), '<P>距离，<SPAN class=cloze>[...]</SPAN></P>')


class CollectionTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = pathlib.Path(self.tmp.name)
        for d in ('info', 'registry', 'elements'):
            (self.root / d).mkdir()
        rtx, mem, ptr = bytearray(), bytearray(), bytearray()
        W.add_text(rtx, mem, ptr, b'root', experimental=True)
        W.add_text(rtx, mem, ptr, b'article', experimental=True)
        W.add_text(rtx, mem, ptr, b'existing child', experimental=True)
        elements, contents = bytearray(), bytearray()
        for slot, title in enumerate((1, 2, 3, -1), 1):
            r = bytearray(118)
            r[0] = 4 if slot == 1 else 0
            struct.pack_into('<i', r, 2, title)
            struct.pack_into('<i', r, 6, -1)
            elements += r
            c = bytearray(37)
            # Root -> article -> existing child; slot 4 is unused.
            values = {1: (0, 2, 2, 2), 2: (1, 3, 3, 1),
                      3: (2, 0, 0, 0), 4: (0, 0, 0, 0)}[slot]
            for off, val in zip((1, 5, 9, 21), values):
                struct.pack_into('<H', c, off, val)
            contents += c
        for rel, data in {'info/ElementInfo.dat': elements,
                          'info/contents.dat': contents, 'info/compon.dat': b'',
                          'registry/Text.rtx': rtx, 'registry/Text.mem': mem,
                          'registry/Text.ptr': ptr,
                          'elements/2.HTM': '<P>距离与距离，转速</P>'.encode(),
                          'elements/3.HTM': '<P>已有子卡：距离与转速</P>'.encode()}.items():
            (self.root / rel).write_bytes(data)

    def test_two_clozes_reopen_and_preserve_existing_children(self):
        sibling = (self.root / 'elements/3.HTM').read_bytes()
        result, err = cloze(str(self.root), 2, '距离', occurrence=2)
        self.assertIsNone(err)
        self.assertEqual(result['slot'], 4)
        child = (self.root / 'elements/4.HTM').read_bytes()
        self.assertIn('<SPAN class=clozed>距离</SPAN>'.encode(), child)
        self.assertTrue(child.startswith('<P>距离与'.encode()))
        result2, err = cloze(str(self.root), 2, '转速')
        self.assertIsNone(err)
        self.assertEqual(result2['slot'], 5)
        self.assertEqual((self.root / 'elements/3.HTM').read_bytes(), sibling)
        self.assertEqual((self.root / 'elements/4.HTM').read_bytes(), child)
        self.assertEqual((self.root / 'elements/2.HTM').read_bytes().count(b'class=cloze>'), 2)
        elements = W.parse_elements((self.root / 'info/ElementInfo.dat').read_bytes())
        blocks = W.component_blocks((self.root / 'info/compon.dat').read_bytes())
        texts = {r['id']: r['text'] for r in W.parse_text((self.root / 'registry/Text.rtx').read_bytes())}
        for e, block, word in zip(elements[3:], blocks, ('距离', '转速')):
            self.assertEqual(e['element_type'], W.TYPE_ITEM)
            self.assertEqual(block['count'], 2)
            self.assertEqual(texts[block['components'][1]['registry_id']], word.encode())
        rows = W.parse_contents((self.root / 'info/contents.dat').read_bytes())
        self.assertEqual(rows[1]['kids'], 3)
        self.assertEqual(rows[2]['next'], 4)
        self.assertEqual(rows[3]['next'], 5)

    def test_dry_run_and_ambiguous_selection_do_not_write(self):
        before = snapshot(self.root)
        _, err = cloze(str(self.root), 2, '距离')
        self.assertIn('ambiguous', err)
        self.assertEqual(snapshot(self.root), before)
        _, err = cloze(str(self.root), 2, '距离', dry_run=True, occurrence=2)
        self.assertIsNone(err)
        self.assertEqual(snapshot(self.root), before)

    def test_unverified_registry_write_requires_explicit_opt_in(self):
        before = snapshot(self.root)
        _, err = raw_cloze(str(self.root), 2, '转速')
        self.assertIn('not fully reconstructed', err)
        _, err = raw_extract(str(self.root), 2, '转速')
        self.assertIn('not fully reconstructed', err)
        self.assertEqual(snapshot(self.root), before)

    def test_pending_recovery_blocks_reading(self):
        from sm_transaction import RecoveryRequired
        (self.root / '.sm-transaction').mkdir()
        with self.assertRaises(RecoveryRequired):
            cloze(str(self.root), 2, '转速', dry_run=True)

    def test_extract_then_cloze_child(self):
        body = (b'AAA first paragraph</P>\r\n<P>BBB second paragraph</P>'
                b'\r\n<P>CCC third paragraph')
        (self.root / 'elements/2.HTM').write_bytes(body)
        result, err = extract(str(self.root), 2, 'BBB second paragraph')
        self.assertIsNone(err)
        self.assertEqual(result['slot'], 4)
        parent_after_extract = (self.root / 'elements/2.HTM').read_bytes()
        item, err = cloze(str(self.root), result['title_id'], 'second')
        self.assertIsNone(err)
        self.assertEqual(item['slot'], 5)
        self.assertEqual((self.root / 'elements/2.HTM').read_bytes(), parent_after_extract)
        self.assertIn(b'class=clozed>second', (self.root / 'elements/5.HTM').read_bytes())


if __name__ == '__main__':
    unittest.main()
