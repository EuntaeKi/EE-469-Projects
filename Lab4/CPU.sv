`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;
	
	/*--- Instruction Fetch Stage ---
	 * 
	 * Input:  MemBrPC, MemBrTaken
	 * Output: FetchPC, FethcInst
	 *
	 */
	 
	logic [63:0] FetchPC, DecBranchPC;
	logic [31:0] FetchInst;
	logic DecBrTaken;
	InstructionFetch theFetchStage (.Instruction(FetchInst), .currentPC(FetchPC), .branchAddress(DecBranchPC), .brTaken(DecBrTaken), .clk, .reset);
	
	/*------------------------------*/
	
	/*--- Fetch -> Dec Register ---
	 *
	 * Input:  FetchInst
	 * Output: DecInst
	 *
	 */ 
	 logic [63:0] DecPC;
	logic [31:0] DecInst;
	InstructionRegister theInstReg (.FetchPC, .FetchInst, .DecPC, .DecInst, .clk, .reset);
	
	/*------------------------------*/
	
	/*--- Control Signals ---
	 *
	 * Input: DecInst, ExNegative, ExOverflow, ExZero
	 * Output: DecALUOp, DecALUSrc, DecMem2Reg, DecBrTaken, DecReg2Loc, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, DecUncondBr
	 *
	 */
	 
	logic [2:0] DecALUOp;
	logic [1:0] DecALUSrc, DecMem2Reg;
   logic 		DecReg2Loc, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, DecUncondBr, DecFlagWrite;
	logic       ExOverflow, ExNegative, ExZero, ExCarryout;
	logic		DecZero, BLTBrTaken, DecBrSrc;

	ControlSignal theControlSignals (.Instruction(DecInst), .ALUOp(DecALUOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), .BrTaken(DecBrTaken), .BrSrc(DecBrSrc), 
												.Reg2Loc(DecReg2Loc), .Reg2Write(DecReg2Write), .RegWrite(DecRegWrite), .MemWrite(DecMemWrite), .MemRead(DecMemRead), 
												.UncondBr(DecUncondBr), .NegativeFlag(ExNegative), .OverflowFlag(ExOverflow), .ZeroFlag(DecZero), .FlagWrite(DecFlagWrite),
												.BLTBrTaken);
	/*----------------------*/
	
	/*--- Forwarding Unit ---
	 *
	 * Input: ExAa, ExAb, ExAw, MemRegWrite, MemRd, WbRegWrite, WbRd
	 * Output: ForwardA, ForwardB
	 */
	logic [4:0] DecAa, DecAb, ExAw, MemAw;
	logic [1:0] ForwardA, ForwardB;
	logic		ExRegWrite, MemRegWrite, WbRegWrite;
	ForwardingUnit theFwdUnit (.DecAa, .DecAb, .ExAw, .MemAw, .ExRegWrite, .MemRegWrite, .ForwardA, .ForwardB);
	
	/*----------------------*/
	
	/*--- Decode Stage ---
	 *
	 * Input:  DecPC, DecInst, DecReg2Loc, DecReg2Write, DecUncondBr, WbMemDataToReg, WbRegWrite
	 * Output: DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecBranchPC
	 *
	 * TODO: Put forwarding unit in theis stage - will output to correct data for Da and Db (WbMemDataToReg, MemALUOut, or DecDa)
	 */
	logic [63:0] DecDa, DecDb, DecImm12Ext, DecImm9Ext;
	logic [4:0]  DecAw, WbAw;
	logic [63:0] WbDataToReg, WbMuxOut, ExALUOut;
	
	InstructionDecode theDecStage (.clk, .reset, .DecPC, .DecInst, .DecReg2Loc, .DecReg2Write, .DecUncondBr, .DecBrSrc, .WbDataToReg, .WbRegWrite, .WbAw,
											 .DecAa, .DecAb, .DecAw, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext, .DecBranchPC, .ForwardA, .ForwardB, .ExALUOut, .WbMuxOut, .DecZero);
	/*-------------------*/
	
	/*--- Dec -> Exec Register	---
	 *
	 * Input:  DecPC, DecALUOp, DecALUSrc, DecMem2Reg, DecBrTaken, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, 
	 *			  DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext
	 * Output: ExPC, ExALUOp, ExALUSrc, ExMem2Reg, ExBrTaken, ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExAa, ExAb, ExAw, ExDa, ExDb, ExImm12Ext, ExImm9Ext
	 *
	 */
	logic [63:0] ExDa, ExDb, ExImm12Ext, ExImm9Ext, ExIncrementedPC;
	logic [31:0] ExcInst;
	logic [2:0]  ExALUOp;
	logic [1:0]  ExALUSrc, ExMem2Reg;
   	logic 		 ExReg2Write, ExMemWrite, ExMemRead, ExFlagWrite;
	
	DecodeRegister theDecReg (.clk, .reset,
				 .DecIncrementedPC(FetchPC), .DecALUOp, .DecALUSrc, .DecMem2Reg, 
				 .DecReg2Write, .DecRegWrite, .DecMemWrite, .DecMemRead, .DecFlagWrite,
				 .DecAw, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext,
				  
				 .ExIncrementedPC, .ExALUOp, .ExALUSrc, .ExMem2Reg, 
				 .ExReg2Write, .ExRegWrite, .ExMemWrite, .ExMemRead, .ExFlagWrite,
				 .ExAw, .ExDa, .ExDb, .ExImm12Ext, .ExImm9Ext);
	/*----------------------*/

	/*--- Execute Stage ---
	 *
	 * Input:  ExPC, ExDa, ExDb, ExALUSrc, ExBrTaken, ExALUOp, ExImm12Ext, ExImm9Ext
	 *			  WbData, MemALUOut, ForwardDa, ForwardDb
	 *
	 * Output: ExBranchPC, ExFwdDb, ExALUOut, ExOverflow, ExNegative, ExZero, ExCarryout
	 */
	 

	Execute theExStage(.clk, .reset, .ExDa, .ExDb, .ExALUSrc, .ExALUOp, .ExFlagWrite, .ExImm12Ext, .ExImm9Ext,
							 .ExALUOut, .ExOverflow, .ExNegative, .ExZero, .ExCarryout, .BLTBrTaken);
	
	/*-------------------*/
	
	/*--- Exec -> Mem Register	---
	 *
	 * Input:  ExPC, ExMem2Reg, ExBrTaken, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExAa, ExAb, ExAw, ExFwdDb, ExBranchPC, ExALUOut
	 * Output: MemPC, MemMem2Reg, MemBrTaken, MemRegWrite, MemMemWrite, MemMemRead,
	 *			  MemRn, MemRm, MemRd, MemDb, MemBranchPC, MemALUOut
	 *
	 */
	logic 		 MemReg2Write, MemMemWrite, MemMemRead;
	logic [63:0] MemIncrementedPC, MemDb, MemALUOut;
	logic [1:0] MemMem2Reg;
	ExecRegister theExReg (.clk, .reset, 
								  .ExIncrementedPC, .ExMem2Reg, .ExRegWrite, .ExMemWrite, 
								  .ExMemRead, .ExAw, .ExDb, .ExALUOut,
								  
								  .MemIncrementedPC, .MemMem2Reg, .MemRegWrite, .MemMemWrite, 
								  .MemMemRead, .MemAw, .MemDb, .MemALUOut
	);
	
	/*-------------------*/
	
	/*--- Execute Stage ---
	 *
	 * Input:  MemALUOut, MemDb, MemMemWrite, MemMemRead
	 *
	 * Output: MemData
	 */
	 
	logic [63:0] MemOut;
	Memory theMemStage(.clk, .reset, .address(MemALUOut), .MemWrite(MemMemWrite), .MemRead(MemMemRead), .MemWriteData(MemDb), .MemOut);
	
	/*------------------*/
	
	/*--- Exec -> Mem Register	---
	 *
	 * Input:  MemPC, MemRd, MemALUOut, MemMem2Reg, MemRegWrite, MemOut
	 * Output: WbPC, WbRd, WbALUOut, WbMem2Reg, WbRegWrite, WbData
	 *
	 */
	 
	logic [63:0] WbPC, WbALUOut;
	logic [1:0]  WbMem2Reg;
	MemoryRegister theMemReg(.clk, .reset, 
							 .MemIncrementedPC, .MemAw, .MemALUOut, .MemMem2Reg, .MemRegWrite, .MemOut, 

							 .WbAw, .WbDataToReg, .WbRegWrite, .WbMuxOut);
	
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
		for (i = 0; i < 1000; i++) begin
			@(posedge clk);
		end
		$stop;
	end	
endmodule
