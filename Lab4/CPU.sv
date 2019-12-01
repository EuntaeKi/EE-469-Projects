`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;
	
	/*--- Instruction Fetch Stage ---*/
	logic [63:0] FetchPC, DecBranchPC;
	logic [31:0] FetchInst;
	logic DecBrTaken;
	
	InstructionFetch theFetchStage (.Instruction(FetchInst), .currentPC(FetchPC), .branchAddress(DecBranchPC), .brTaken(DecBrTaken), .clk, .reset);
	/*------------------------------*/
	
	/*--- Fetch -> Dec Register ---*/
	logic [63:0] DecPC;
	logic [31:0] DecInst;
	
	InstructionRegister theInstReg (.FetchPC, .FetchInst, .DecPC, .DecInst, .clk, .reset);
	/*------------------------------*/
	
	/*--- Control Signals ---*/
	logic [2:0] DecALUOp;
	logic [1:0] DecALUSrc, DecMem2Reg;
   logic 		DecBrSrc, DecReg2Loc, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, DecUncondBr, DecFlagWrite, DecZero, BLTBrTaken, ExOverflow, ExNegative;		

	ControlSignal theControlSignals (.Instruction(DecInst), .ALUOp(DecALUOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), 
												.BrTaken(DecBrTaken), .BrSrc(DecBrSrc), .Reg2Loc(DecReg2Loc), .Reg2Write(DecReg2Write), 
												.RegWrite(DecRegWrite), .MemWrite(DecMemWrite), .MemRead(DecMemRead), .UncondBr(DecUncondBr), 
												.NegativeFlag(ExNegative), .OverflowFlag(ExOverflow), .ZeroFlag(DecZero), .FlagWrite(DecFlagWrite), .BLTBrTaken
	);
	/*----------------------*/
	
	/*--- Forwarding Unit ---*/
	logic [4:0] DecAa, DecAb, ExAw, MemAw;
	logic [1:0] ForwardA, ForwardB;
	logic		ExRegWrite, MemRegWrite, WbRegWrite;
	ForwardingUnit theFwdUnit (.DecAa, .DecAb, .ExAw, .MemAw, .ExRegWrite, .MemRegWrite, .ForwardA, .ForwardB);
	/*----------------------*/
	
	/*--- Decode Stage ---*/
	logic [63:0] DecDa, DecDb, DecImm12Ext, DecImm9Ext;
	logic [4:0]  DecAw, WbAw;
	logic [63:0] WbDataToReg, WbMuxOut, ExALUOut;
	
	InstructionDecode theDecStage (.clk, .reset, .DecPC, .DecInst, .DecReg2Loc, .DecReg2Write, .DecUncondBr, .DecBrSrc, 
											 .WbDataToReg, .WbRegWrite, .WbAw, .DecAa, .DecAb, .DecAw, .DecDa, .DecDb, .DecImm12Ext, 
											 .DecImm9Ext, .DecBranchPC, .ForwardA, .ForwardB, .ExALUOut, .WbMuxOut, .DecZero
	);
	/*-------------------*/
	
	/*--- Dec -> Exec Register	---*/
	logic [63:0] ExDa, ExDb, ExImm12Ext, ExImm9Ext, ExIncrementedPC;
	logic [31:0] ExcInst;
	logic [2:0]  ExALUOp;
	logic [1:0]  ExALUSrc, ExMem2Reg;
   logic 		 ExMemWrite, ExMemRead, ExFlagWrite;
	
	DecodeRegister theDecReg (.clk, .reset,
									  .DecIncrementedPC(FetchPC), .DecALUOp, .DecALUSrc, .DecMem2Reg, 
									  .DecRegWrite, .DecMemWrite, .DecMemRead, .DecFlagWrite,
									  .DecAw, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext,
									   
									  .ExIncrementedPC, .ExALUOp, .ExALUSrc, .ExMem2Reg, 
									  .ExRegWrite, .ExMemWrite, .ExMemRead, .ExFlagWrite,
									  .ExAw, .ExDa, .ExDb, .ExImm12Ext, .ExImm9Ext
	);
	/*----------------------*/

	/*--- Execute Stage ---*/
	logic ExZero, ExCarryout;
	Execute theExStage(.clk, .reset, .ExDa, .ExDb, .ExALUSrc, .ExALUOp, .ExFlagWrite, .ExImm12Ext, .ExImm9Ext,
							 .ExALUOut, .ExOverflow, .ExNegative, .ExZero, .ExCarryout, .BLTBrTaken);
	
	/*-------------------*/
	
	/*--- Exec -> Mem Register	---*/
	logic [63:0] MemIncrementedPC, MemDb, MemALUOut;
	logic [1:0]  MemMem2Reg;
	logic 		 MemMemWrite, MemMemRead;
	
	ExecRegister theExReg (.clk, .reset, 
								  .ExIncrementedPC, .ExMem2Reg, .ExRegWrite, .ExMemWrite, 
								  .ExMemRead, .ExAw, .ExDb, .ExALUOut,
								  
								  .MemIncrementedPC, .MemMem2Reg, .MemRegWrite, .MemMemWrite, 
								  .MemMemRead, .MemAw, .MemDb, .MemALUOut
	);
	/*-------------------*/
	
	/*--- Execute Stage ---*/
	logic [63:0] MemOut;
	
	Memory theMemStage(.clk, .reset, .address(MemALUOut), .MemWrite(MemMemWrite), .MemRead(MemMemRead), .MemWriteData(MemDb), .MemOut);
	/*------------------*/
	
	/*--- Exec -> Mem Register	---*/
	MemoryRegister theMemReg(.clk, .reset, 
							 .MemIncrementedPC, .MemAw, .MemALUOut, .MemMem2Reg, .MemRegWrite, .MemOut, 

							 .WbAw, .WbDataToReg, .WbRegWrite, .WbMuxOut
	);
	/*-------------------*/

endmodule 

module cpu_tb();
	logic clk, reset;
	
	CPU dut (.clk(clk), .reset(reset));
	
	parameter CLOCK_PERIOD = 10000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	int i;
	initial begin
		reset = 1; @(posedge clk); @(posedge clk);
		reset = 0; @(posedge clk);
		for (i = 0; i < 100; i++) begin
			@(posedge clk);
		end
		$stop;
	end	
endmodule
