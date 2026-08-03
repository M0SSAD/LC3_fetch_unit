import pckg::*;
program fetch_test(fetch_inf.tb inf, fetch_inf.monitor mnt);
    logic [DEFAULT_ADDR_WIDTH-1:0] pc_before;
    cntrl_e busy_states[3] = '{CNTRL_READ_MEMORY, CNTRL_IND_ADDR_RD, CNTRL_WRITE_MEM};

    initial begin
        // reseting the pc reg.
        $display("TEST @%0t: Reseting the PC, and initializing all the signals.", $realtime);
        inf.cb.reset <= 1'b1;
        inf.cb.taddr <= 16'hFFFD;
        inf.cb.br_taken <= 0;
        inf.cb.state <= CNTRL_UPDATE_PC;
        repeat(2) @(inf.cb); // wait two cycles
        inf.cb.reset <= 1'b0;
        @(inf.cb);
        
        pc_post_reset: assert (inf.cb.pc == 16'h3000 && inf.cb.npc == 16'h3001)
                    $display("ASSERTION PASSED @%0t: Pc Was set correctly to 16'h3000", $realtime);
                    else $fatal(1, "ASSERTION FAILED @%0t: PC WASN'T RESET CORRECTLY.", $realtime);
        
        repeat(2) @(inf.cb); // wait two cycles
        
        $display("TEST @%0t: Checking that the Pc is updated", $realtime);
        pc_after_two_cycle: assert(inf.cb.pc == 16'h3002 && inf.cb.npc == 16'h3003)
                        $display("ASSERTION PASSED @%0t: Pc Was Updated Correctly.", $realtime);
                    else $fatal(1, "ASSERTION FAILED @%0t: PC WASN'T SET CORRECTLY.", $realtime);

        $display("TEST @%0t: Checking that taddr is ignored when br_taken is 0", $realtime);
        inf.cb.taddr <= 16'h1234;
        inf.cb.br_taken <= 1'b0;
        @(inf.cb);
        pc_no_branch: assert (inf.cb.pc == 16'h3003 && inf.cb.npc == 16'h3004)
                    $display("ASSERTION PASSED @%0t: Pc Was updated normally when br_taken was 0.", $realtime);
                    else $fatal(1, "ASSERTION FAILED @%0t: PC used taddr even though br_taken was 0.", $realtime);
        

        $display("TEST @%0t: Checking the branch taken", $realtime);
        inf.cb.taddr <= 16'hFFFD;
        inf.cb.br_taken <= 1;
        @(inf.cb); // wait one cycle until the DUT samples it
        inf.cb.br_taken <= 0;
        @(inf.cb); // wait one cycle until the DUT samples ittttttttttttttt
        pc_post_branch: assert (inf.cb.pc == 16'hFFFD && inf.cb.npc == 16'hFFFE)
                    $display("ASSERTION PASSED @%0t: Pc Was set correctly to 16'hFFFD", $realtime);
                    else $fatal(1, "ASSERTION FAILED @%0t: THE BRANCH WASN'T TAKEN.", $realtime);

        @(inf.cb);
        $display("TEST @%0t: Checking if the PC will rollover after it reachs 16'hFFFF", $realtime);
        @(inf.cb); // 16'hFFFF
        @(inf.cb);// 16'h0000
        pc_rollover: assert (inf.cb.pc == 16'h0000 && inf.cb.npc == 16'h0001)
                    $display("ASSERTION PASSED @%0t: Pc Was set correctly to 16'h0000", $realtime);
                    else $fatal(1, "ASSERTION FAILED @%0t: THE PC DIDN't ROLLOVER.", $realtime);
        
        @(inf.cb);
        $display("TEST @%0t: Checking if the pc is only updated when the state is CNTRL_UPDATE_PC", $realtime);
        inf.cb.state <=  CNTRL_TEST;
        @(inf.cb); // wait until the DUT samples the state.
        pc_before = inf.cb.pc;
        repeat(5) begin
            @(inf.cb);
            assert (inf.cb.pc == pc_before && inf.cb.npc == pc_before + 1 && inf.cb.rd == 1'b1)
            else $fatal(1, "ASSERTION FAILED @PC changed while state was CNTRL_TEST.");
        end

        $display("TEST @%0t: Checking pc and rd tri-state behavior in memory busy states", $realtime);
        inf.cb.state <= CNTRL_UPDATE_PC;
        inf.cb.br_taken <= 1'b0;
        inf.cb.taddr <= 16'hFFFD;
        @(inf.cb);
        foreach (busy_states[i]) begin
            inf.cb.state <= busy_states[i];
            @(inf.cb);
            assert (inf.cb.pc === {DEFAULT_ADDR_WIDTH{1'bz}} && inf.cb.rd === 1'bz)
                $display("ASSERTION PASSED @%0t: pc and rd are tri-stated in %s.", $realtime, busy_states[i].name);
            else $fatal(1, "ASSERTION FAILED @%0t: pc/rd were not tri-stated in %s.", $realtime, busy_states[i].name);
            inf.cb.state <= CNTRL_UPDATE_PC;
            @(inf.cb);
        end


        $display("TEST @%0t: SIMULATION ENDED WITH ALL TESTS PASSED.", $realtime);
    end

    initial begin : MONITOR
        $monitor("MONITOR @%0t: pc=%0h, npc=%0h, rd=%0b, state=%s, taddr=%0h, br_taken=%0b", $realtime, mnt.cbm.pc, mnt.cbm.npc, mnt.cbm.rd, mnt.cbm.state.name, mnt.cbm.taddr, mnt.cbm.br_taken);
    end

endprogram