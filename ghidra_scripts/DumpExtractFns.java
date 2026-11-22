// Decompile the extract-markup functions and write them to a file.
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import java.io.PrintWriter;

public class DumpExtractFns extends GhidraScript {

    private void emit(DecompInterface d, long va, String label, PrintWriter w) {
        Address a = toAddr(va);
        Function f = getFunctionAt(a);
        if (f == null) f = getFunctionContaining(a);
        if (f == null) {
            w.println("=== " + label + ": no function at 0x" + Long.toHexString(va));
            return;
        }
        w.println("");
        w.println("==================================================================");
        w.println("=== " + label);
        w.println("=== " + f.getName() + " @ " + f.getEntryPoint() +
                    "  body=" + f.getBody().getNumAddresses() + " bytes");
        w.println("==================================================================");
        DecompileResults r = d.decompileFunction(f, 240, monitor);
        if (r != null && r.decompileCompleted() && r.getDecompiledFunction() != null) {
            w.println(r.getDecompiledFunction().getC());
        } else {
            w.println("decompile failed: " + (r == null ? "null" : r.getErrorMessage()));
        }
        w.flush();
    }

    @Override
    public void run() throws Exception {
        DecompInterface d = new DecompInterface();
        d.setOptions(new DecompileOptions());
        d.openProgram(currentProgram);

        PrintWriter w = new PrintWriter("F:\\Projects\\逆向\\work\\extract_fns.c", "UTF-8");
        w.println("// decompiled from sm19.exe by Ghidra 12.2");
        emit(d, 0xb2f61cL, "builds <SPAN class=extract", w);
        emit(d, 0xb51164L, "builds <span class=extract>", w);
        w.close();
        d.dispose();
        println("wrote F:\\Projects\\逆向\\work\\extract_fns.c");
    }
}
