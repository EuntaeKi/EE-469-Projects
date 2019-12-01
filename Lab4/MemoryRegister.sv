module MemoryRegister (clk, reset, MemIncrementedPC, MemAw, MemALUOut, MemMem2Reg, MemRegWrite, MemOut, 
                        WbAw, WbDataToReg, WbRegWrite, WbMuxOut);
    
    // Input Logic (Data & Control Signal)
   input  logic        clk, reset;
	input  logic 		  MemRegWrite;
   input  logic [1:0]  MemMem2Reg;
   input  logic [4:0]  MemAw;
   input  logic [63:0] MemIncrementedPC, MemOut, MemALUOut;

    // Output Logic (Data & Control Signal)
	output logic 		WbRegWrite;
	output logic [4:0]  WbAw;
   output logic [63:0] WbDataToReg, WbMuxOut;
	
	mux4to1_64bit MuxRegWriteBack (.select(MemMem2Reg), .in({64'bX, MemIncrementedPC, MemOut, MemALUOut}), .out(WbMuxOut));
	 
	registerN #(.N(64)) WbDataReg (.reset, .clk, .in(WbMuxOut), .out(WbDataToReg));
    registerN #(.N(5)) RdReg (.reset, .clk, .in(MemAw), .out(WbAw));

    D_FF RegWriteReg (.q(WbRegWrite), .d(MemRegWrite), .reset, .clk);

endmodule