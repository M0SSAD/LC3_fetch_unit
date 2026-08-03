import pckg::*;
interface fetch_inf (input bit clk);
    parameter int aw = DEFAULT_ADDR_WIDTH;
    logic [aw - 1:0] taddr;
    logic br_taken, reset, clock;
    cntrl_e state;
    logic [aw - 1:0] npc, pc;
    logic rd;

    clocking cb @(posedge clk);
        input pc, npc, rd;
        output taddr, br_taken, reset, state;
    endclocking

    modport tb(clocking cb);
    modport dut(input clk, reset, br_taken, taddr, state, output pc, npc, rd);

    clocking cbm @(posedge clk);
        input pc, npc, rd, taddr, br_taken, reset, state;
    endclocking
    modport monitor(clocking cbm);
endinterface