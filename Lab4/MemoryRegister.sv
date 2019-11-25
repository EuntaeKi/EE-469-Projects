module MemoryRegister (clk, reset, MemRd, MemALUOut, MemMem2Reg, MemRegWrite, MemData, 
                        WbRd, WbALUOut, WbMem2Reg, WbRegWrite, WbData);
    
    // Input Logic (Data & Control Signal)
    input  logic        clk, reset;
	input  logic 		MemRegWrite;
    input  logic [1:0]  MemMem2Reg;
    input  logic [4:0]  MemRd;
    input  logic [63:0] MemData, MemALUOut;

    // Output Logic (Data & Control Signal)
	output logic 		WbRegWrite;
    output logic [1:0]  WbMem2Reg;
    output logic [4:0]  WbRd;
    output logic [63:0] WbData, WbALUOut;

    register64 MemOutputReg (.reset, .clk, .write(1'b1), .in(MemData), .out(WbData));
    register64 MemALUOutReg (.reset, .clk, .write(1'b1), .in(MemALUOut), .out(WbALUOut));

    registerN #(.N(5)) Mem2RegReg (.reset, .clk, .in(MemRd), .out(WbRd));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(MemMem2Reg), .out(WbMem2Reg));

    D_FF RegWriteReg (.q(WbRegWrite), .d(MemRegWrite), .reset, .clk);

endmodule