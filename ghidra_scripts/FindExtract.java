// Locate functions related to Extract and dump key ones.
// The extraction markup strings live at 0x00b2f74c ('<SPAN class=extract')
// and 0x00b51a64 ('<span class=extract>').
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.symbol.Reference;
import ghidra.program.model.symbol.ReferenceIterator;

public class FindExtract extends GhidraScript {

    private void refsTo(long va, String label) {
        Address a = toAddr(va);
        println("=== references to " + label + " (0x" + Long.toHexString(va) + ") ===");
        ReferenceIterator it = currentProgram.getReferenceManager().getReferencesTo(a);
        int n = 0;
        while (it.hasNext()) {
            Reference r = it.next();
            Address from = r.getFromAddress();
            Function f = getFunctionContaining(from);
            String fname = (f == null) ? "<no function>" : (f.getName() + " @ " + f.getEntryPoint());
            println("  from " + from + "  in " + fname);
            if (++n >= 20) { println("  ..."); break; }
        }
        if (n == 0) println("  (none)");
    }

    @Override
    public void run() throws Exception {
        println("=== " + currentProgram.getName() +
                "  functions=" + currentProgram.getFunctionManager().getFunctionCount());

        refsTo(0x00b2f74cL, "<SPAN class=extract");
        refsTo(0x00b51a64L, "<span class=extract>");
        refsTo(0x00b3268cL, "<SPAN class=extract (2)");
        refsTo(0x00b79678L, "class=extract");

        println("");
        println("=== functions whose name mentions extract ===");
        int n = 0;
        for (Function f : currentProgram.getFunctionManager().getFunctions(true)) {
            String nm = f.getName().toLowerCase();
            if (nm.contains("extract")) {
                println("  " + f.getEntryPoint() + "  " + f.getName() +
                        "  body=" + f.getBody().getNumAddresses());
                if (++n >= 50) { println("  ..."); break; }
            }
        }
        if (n == 0) println("  (none - Delphi binary is stripped)");
    }
}
