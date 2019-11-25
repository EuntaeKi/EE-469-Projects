module WriteBack (clk, reset, MemOutput, ALUOutput, Mem2Reg, WbOutput);
    input  logic        clk, reset;
    input  logic [63:0] MemOutput, ALUOutput;
    input  logic        Mem2Reg;

    output logic [63:0] WbOutput;

    mux2to1_Nbit #(.N(64)) MuxRegWriteBack (.en(Mem2Reg), .a(ALUOutput), .b(MemOutput), .out(WbOutput));

endmodule