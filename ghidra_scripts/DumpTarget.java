// Disassemble a region one instruction at a time (FlatProgramAPI.disassemble
// takes a single Address), create a function, then decompile it.
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.Instruction;

public class DumpTarget extends GhidraScript {

    private int sweep(Address from, Address to) {
        int count = 0;
        Address cur = from;
        while (cur.compareTo(to) < 0) {
            if (disassemble(cur)) {
                Instruction ins = getInstructionAt(cur);
                if (ins == null) { cur = cur.add(1); continue; }
                count++;
                cur = cur.add(ins.getLength());
            } else {
                cur = cur.add(1);
            }
        }
        return count;
    }

    private void dump(DecompInterface d, long start, long len) {
        Address a = toAddr(start);
        Address end = toAddr(start + len);
        println("=== region 0x" + Long.toHexString(start) + " .. 0x" + Long.toHexString(start + len) + " ===");

        int n = sweep(a, end);
        println("  disassembled instructions: " + n);

        Function f = getFunctionAt(a);
        if (f == null) {
            try { f = createFunction(a, null); } catch (Exception e) {
                println("  createFunction: " + e.getMessage());
            }
        }
        if (f == null) {
            Instruction ins = getInstructionAt(a);
            int k = 0;
            while (ins != null && k < 15) {
                println("    " + ins.getAddress() + "  " + ins.toString());
                ins = ins.getNext(); k++;
            }
            return;
        }
        println("  function " + f.getName() + " @ " + f.getEntryPoint() +
                "  body=" + f.getBody().getNumAddresses() + " bytes");
        DecompileResults r = d.decompileFunction(f, 180, monitor);
        if (r != null && r.decompileCompleted()) {
            println(r.getDecompiledFunction().getC());
        } else {
            println("  decompile failed: " + (r == null ? "null" : r.getErrorMessage()));
        }
    }

    @Override
    public void run() throws Exception {
        DecompInterface d = new DecompInterface();
        d.openProgram(currentProgram);
        println("=== " + currentProgram.getName() + "  functions=" +
                currentProgram.getFunctionManager().getFunctionCount());

        // "Cannot compute the optimum interval" string is at 0x007c6d9c,
        // so the containing function begins somewhere below it.
        dump(d, 0x7c6c80L, 0x180);
        d.dispose();
    }
}
