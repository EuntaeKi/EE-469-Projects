module MemoryRegister (clk, reset, MemOutput, MemALUOutput, MemMem2Reg, MemRegWrite, WbMemOutput, WbALUOutput, WbMem2Reg, WbRegWrite);
    // Input Logic (Data & Control Signal)
    input  logic        clk, reset;
	 input  logic 			MemRegWrite;
    input  logic [1:0]  MemMem2Reg;
    input  logic [63:0] MemOutput, MemALUOutput;

    // Output Logic (Data & Control Signal)
    output logic        WbRegWrite;
	 output logic [1:0]  WbMem2Reg;
    output logic [63:0] WbMemOutput, WbALUOutput;

    register64 MemOutputReg (.reset, .clk, .write(1'b1), .in(MemOutput), .out(WbMemOutput));
    register64 MemALUOutputReg (.reset, .clk, .write(1'b1), .in(MemALUOutput), .out(WbALUOutput));

    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(MemMem2Reg), .out(WbMem2Reg));
    D_FF RegWriteReg (.q(WbRegWrite), .d(MemRegWrite), .reset, .clk);

endmodule