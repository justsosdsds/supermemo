// Dump disassembled instructions across a region, marking call/jump targets and
// string references so the logic can be read without relying on function
// boundary detection (which is unreliable on this stripped Delphi binary).
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.scalar.Scalar;

public class DumpRegion extends GhidraScript {

    private void sweep(Address from, Address to) {
        Address cur = from;
        int n = 0;
        while (cur.compareTo(to) < 0 && n < 4000) {
            if (disassemble(cur)) {
                Instruction ins = getInstructionAt(cur);
                if (ins == null) { cur = cur.add(1); continue; }
                StringBuilder sb = new StringBuilder();
                sb.append(ins.getAddress()).append("  ").append(ins.toString());

                // annotate call targets and immediate references
                for (int i = 0; i < ins.getNumOperands(); i++) {
                    Object[] objs = ins.getOpObjects(i);
                    for (Object o : objs) {
                        if (o instanceof Scalar) {
                            long v = ((Scalar) o).getUnsignedValue();
                            if (v >= 0x400000L && v < 0xd00000L) {
                                sb.append("   ; ref 0x").append(Long.toHexString(v));
                            }
                        }
                    }
                }
                println(sb.toString());
                n++;
                cur = cur.add(ins.getLength());
            } else {
                cur = cur.add(1);
            }
        }
        println("  (instructions: " + n + ")");
    }

    @Override
    public void run() throws Exception {
        println("=== " + currentProgram.getName() + " ===");
        // region around the "Cannot compute the optimum interval" string 0x007c6d9c
        println("--- region A: 0x7c6c00..0x7c6e20 ---");
        sweep(toAddr(0x7c6c00L), toAddr(0x7c6e20L));
    }
}
