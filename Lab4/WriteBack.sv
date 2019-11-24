module WriteBack (clk, reset, MemOutput, ALUOutput, RegWrite, Mem2Reg, WbOutput);
    input  logic        clk, reset;
    input  logic [63:0] MemOutput, ALUOutput;
    input  logic        RegWrite, Mem2Reg;

    output logic [63:0] WbOutput;

    

endmodule