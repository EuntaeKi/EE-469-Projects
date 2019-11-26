module WriteBack (clk, reset, MemOutput, ALUOutput, WbPC, Mem2Reg, WbDataToReg);
    input  logic        clk, reset;
    input  logic [63:0] MemOutput, WbPC, ALUOutput;
    input  logic [1:0]       Mem2Reg;

    output logic [63:0] WbDataToReg;

	 logic [63:0]  incrementedPC;
	 fullAdder_64 thePCAdder (.result(incrementedPC), .A(WbPC), .B(64'd4), .cin(1'b0), .cout());

    mux4to1_64bit MuxRegWriteBack (.select(Mem2Reg), .in({64'bX, WbPC, MemOutput, ALUOutput}), .out(WbDataToReg));

endmodule