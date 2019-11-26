module WriteBack (clk, reset, MemOutput, ALUOutput, Mem2Reg, WbDataToReg);
    input  logic        clk, reset;
    input  logic [63:0] MemOutput, ALUOutput;
    input  logic        Mem2Reg;

    output logic [63:0] WbDataToReg;

    mux2to1_Nbit #(.N(64)) MuxRegWriteBack (.en(Mem2Reg), .a(ALUOutput), .b(MemOutput), .out(WbDataToReg));

endmodule