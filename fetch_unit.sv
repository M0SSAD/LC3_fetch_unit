import pckg::*;
module fetch_unit(fetch_inf.dut inf);
    wire logic [inf.aw-1:0] nodeA, nodeB, nodeC;
    wire memory_free = (inf.state!=CNTRL_READ_MEMORY)&&(inf.state!=CNTRL_IND_ADDR_RD)&&(inf.state!=CNTRL_WRITE_MEM);
    logic [inf.aw-1:0] pc_reg;
    assign inf.npc = pc_reg + 1;
    assign nodeA = inf.br_taken? inf.taddr : inf.npc;
    assign nodeB = (inf.state == CNTRL_UPDATE_PC) ? nodeA : pc_reg;
    assign nodeC = (inf.reset) ? 16'h3000 : nodeB; 
    always_ff @(posedge inf.clk) begin
        pc_reg <= nodeC;
    end 
    assign inf.pc = memory_free ? pc_reg : {inf.aw{1'bz}};
    assign inf.rd = memory_free? 1'b1 : 1'bz;
endmodule