module MemoryRegister (clk, reset, MemPC, MemRd, MemALUOut, MemMem2Reg, MemRegWrite, MemOut, 
                        WbRd, WbDataToReg, WbRegWrite);
    
    // Input Logic (Data & Control Signal)
   input  logic        clk, reset;
	input  logic 		  MemRegWrite;
   input  logic [1:0]  MemMem2Reg;
   input  logic [4:0]  MemRd;
   input  logic [63:0] MemPC, MemOut, MemALUOut;

    // Output Logic (Data & Control Signal)
	output logic 		WbRegWrite;
	output logic [4:0]  WbRd;
   output logic [63:0] WbDataToReg, WbMuxOut;
	
	mux4to1_64bit MuxRegWriteBack (.select(MemMem2Reg), .in({64'bX, MemPC, MemOut, MemALUOut}), .out(WbMuxOut));
	 
	registerN #(.N(64)) RdReg (.reset, .clk, .in(WbMuxOut), .out(WbDataToReg));
    registerN #(.N(5)) RdReg (.reset, .clk, .in(MemRd), .out(WbRd));

    D_FF RegWriteReg (.q(WbRegWrite), .d(MemRegWrite), .reset, .clk);

endmodule