module MemoryRegister (clk, reset, MemPC, MemRd, MemALUOut, MemMem2Reg, MemRegWrite, MemOut, 
                        WbPC, WbRd, WbALUOut, WbMem2Reg, WbRegWrite, WbData);
    
    // Input Logic (Data & Control Signal)
    input  logic        clk, reset;
	input  logic 		MemRegWrite;
    input  logic [1:0]  MemMem2Reg;
    input  logic [4:0]  MemRd;
    input  logic [63:0] MemPC, MemOut, MemALUOut;

    // Output Logic (Data & Control Signal)
	output logic 		WbRegWrite;
    output logic [1:0]  WbMem2Reg;
    output logic [4:0]  WbRd;
    output logic [63:0] WbPC, WbData, WbALUOut;

    register64 MemOutputReg (.reset, .clk, .write(1'b1), .in(MemOut), .out(WbData));
    register64 MemALUOutReg (.reset, .clk, .write(1'b1), .in(MemALUOut), .out(WbALUOut));
    register64 MemPCReg (.reset, .clk, .write(1'b1), .in(MemPC), .out(WbPC));
	 
    registerN #(.N(5)) RdReg (.reset, .clk, .in(MemRd), .out(WbRd));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(MemMem2Reg), .out(WbMem2Reg));

    D_FF RegWriteReg (.q(WbRegWrite), .d(MemRegWrite), .reset, .clk);

endmodule