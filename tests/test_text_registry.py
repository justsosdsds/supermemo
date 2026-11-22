"""Regression checks for the verified fields, not a native compatibility claim."""
import struct
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
import smwrite as W


class TextRegistryTests(unittest.TestCase):
    def test_native_sample_field_layout(self):
        # EXTEST Text.mem row 1, read-only original-program fixture.
        observed = bytes.fromhex(
            '01 00 00 00 03 00 00 00 00 00 01 00 00 00 0c 00 '
            '00 00 01 00 00 00 00 00 00 00 00 00 00 00')
        self.assertEqual(W.encode_text_mem_record(
            1, 12, use_count=1, lst_related=1), observed)

    def test_large_offsets_and_lengths_are_full_int32(self):
        for offset in (32767, 32768, 65536, 1315989):
            rec = W.encode_text_mem_record(offset, 90006)
            self.assertEqual(struct.unpack_from('<iii', rec, 10),
                             (offset, 90006, 0))
            self.assertEqual(rec[6:10], bytes(4))

    def test_large_chinese_text_appends_twice(self):
        rtx, mem, ptr = bytearray(), bytearray(), bytearray()
        text = ('中文文章' * 20000).encode('utf8')
        for expected_id in (1, 2):
            offset = len(rtx)
            actual_id = W.add_text(rtx, mem, ptr, text, experimental=True)
            self.assertEqual(actual_id, expected_id)
            row = mem[(expected_id - 1) * 30:expected_id * 30]
            start, length = struct.unpack_from('<ii', row, 10)
            self.assertEqual(start, offset + 1)
            self.assertEqual(length, len(text) + 6)
            blob = rtx[start - 1:start - 1 + length]
            self.assertEqual(blob[:-6], text)
            self.assertEqual(struct.unpack('<i', blob[-5:-1])[0], expected_id)

    def test_id_comes_from_mem_row_not_pointer_order(self):
        rtx, mem = bytearray(), bytearray(30 * 3)
        ptr = bytearray(struct.pack('<ii', 3, 1))
        self.assertEqual(W.add_text(rtx, mem, ptr, b'text', experimental=True), 4)

    def test_default_rejects_before_mutating(self):
        buffers = [bytearray(), bytearray(), bytearray()]
        with self.assertRaisesRegex(ValueError, 'Text.lst'):
            W.add_text(*buffers, b'text')
        self.assertEqual(buffers, [bytearray(), bytearray(), bytearray()])

    def test_bad_inputs_do_not_partially_append(self):
        for mem, ptr, text in [(bytearray(1), bytearray(), b'ok'),
                               (bytearray(), bytearray(1), b'ok'),
                               (bytearray(), bytearray(), b'bad\x00text')]:
            buffers = [bytearray(b'existing'), mem, ptr]
            before = [bytes(x) for x in buffers]
            with self.assertRaises(ValueError):
                W.add_text(*buffers, text, experimental=True)
            self.assertEqual([bytes(x) for x in buffers], before)

    def test_inconsistent_backlinks_rejected(self):
        with self.assertRaises(ValueError):
            W.encode_text_mem_record(1, 12, use_count=1, lst_related=0)


if __name__ == '__main__':
    unittest.main()
