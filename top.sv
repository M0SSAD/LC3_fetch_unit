package pckg;
    localparam int DEFAULT_ADDR_WIDTH = 16;
    localparam time CLOCK_PERIOD = 10;
    typedef enum logic [3:0] {
        CNTRL_UPDATE_PC = 4'b1010,
        CNTRL_READ_MEMORY = 4'b0110,
        CNTRL_IND_ADDR_RD = 4'b0111,
        CNTRL_WRITE_MEM = 4'b1000
    } cntrl_e;
endpackage

module top();
    bit clk;
    always #(pckg::CLOCK_PERIOD/2) clk = ~clk;
    fetch_inf inf(clk);
    fetch_unit dut(inf.dut);
endmodule