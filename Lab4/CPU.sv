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
	 
	logic [63:0] FetchPC;
	logic [31:0] FetchInst;
	logic [63:0] MemALUOut, MemImmBranch, MemDb;
	logic [1:0]  MemBrTaken, MemMem2Reg;
	InstructionFetch theFetchStage (.Instruction(FetchInst), .currentPC(FetchPC), .branchAddress(MemImmBranch), .Db(MemALUOut), .brTaken(MemBrTaken), .clk, .reset);
	
	/*------------------------------*/
	
	/*--- Fetch -> Dec Register ---
	 *
	 * Input:  FetchPC, FetchInst
	 * Output: DecPC, DecInst
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
	logic [1:0] DecBrTaken, DecALUSrc, DecMem2Reg;
   logic 		DecReg2Loc, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, DecUncondBr;
	logic        ExOverflow, ExNegative, ExZero, ExCarryout;
	
	ControlSignal theControlSignals (.Instruction(DecInst), .ALUOp(DecALUOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), .BrTaken(DecBrTaken),
												.Reg2Loc(DecReg2Loc), .Reg2Write(DecReg2Write), .RegWrite(DecRegWrite), .MemWrite(DecMemWrite), .MemRead(DecMemRead), 
												.UncondBr(DecUncondBr), .NegativeFlag(ExNegative), .OverflowFlag(ExOverflow), .ZeroFlag(ExZero));
	/*----------------------*/
	
	/*--- Forwarding Unit ---
	 *
	 * Input: ExAa, ExAb, ExAw, MemRegWrite, MemRd, WbRegWrite, WbRd
	 * Output: ForwardDa, ForwardDb
	 */
	logic [4:0] ExAa, ExAb, ExAw, MemRn, MemRm, MemRd, WbRd;
	logic [1:0] ForwardDa, ForwardDb;
	logic			MemRegWrite, WbRegWrite;
	ForwardingUnit theFwdUnit (.ExAa, .ExAb, .ExAw, .MemRd, .WbRd, .MemRegWrite, .WbRegWrite, .ForwardDa, .ForwardDb);
	
	/*----------------------*/
	
	/*--- Decode Stage ---
	 *
	 * Input:  DecInst, DecReg2Loc, DecReg2Write, DecUncondBr, WbMemDataToReg, WbRegWrite
	 * Output: DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch
	 */
	logic [63:0] DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch;
	logic [4:0]  DecAa, DecAb, DecAw;
	logic [63:0] WbDataToReg;
	
	InstructionDecode theDecStage (.clk, .reset, .DecInst, .DecReg2Loc, .DecReg2Write, .DecUncondBr, .WbMemDataToReg(WbDataToReg), .WbRegWrite, 
											 .DecAa, .DecAb, .DecAw, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext, .DecImmBranch);
	/*-------------------*/
	
	/*--- Dec -> Exec Register	---
	 *
	 * Input:  DecPC, DecALUOp, DecALUSrc, DecMem2Reg, DecBrTaken, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, 
	 *			  DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch
	 * Output: ExPC, ExALUOp, ExALUSrc, ExMem2Reg, ExBrTaken, ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExAa, ExAb, ExAw, ExDa, ExDb, ExImm12Ext, ExImm9Ext, ExImmBranch
	 *
	 */
	logic [63:0] ExPC, ExDa, ExDb, ExImm12Ext, ExImm9Ext, ExImmBranch;
	logic [31:0] ExcInst;
	logic [2:0]  ExALUOp;
	logic [1:0]  ExBrTaken, ExALUSrc, ExMem2Reg;
   logic 		 ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead;
	
	DecodeRegister theDecReg (.clk, .reset,
				 .DecPC, .DecALUOp, .DecALUSrc, .DecMem2Reg, .DecBrTaken, 
				 .DecReg2Write, .DecRegWrite, .DecMemWrite, .DecMemRead, 
				 .DecAa, .DecAb, .DecAw, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext, .DecImmBranch,
				  
				 .ExPC, .ExALUOp, .ExALUSrc, .ExMem2Reg, .ExBrTaken, 
				 .ExReg2Write, .ExRegWrite, .ExMemWrite, .ExMemRead, 
				 .ExAa, .ExAb, .ExAw, .ExDa, .ExDb, .ExImm12Ext, .ExImm9Ext, .ExImmBranch);
	/*----------------------*/

	/*--- Execute Stage ---
	 *
	 * Input:  ExDa, ExDb, ExALUSrc, ExBrTaken, ExALUOp, ExImm12Ext, ExImm9Ext,
	 *			  WbData, MemALUOut, ForwardDa, ForwardDb
	 *
	 * Output: ExFwdDb, ExALUOut, ExOverflow, ExNegative, ExZero, ExCarryout
	 */
	 
	logic [63:0] ExALUOut, ExFwdDb;
	
	Execute theExStage(.clk, .reset, .ExDa, .ExDb, .ExALUSrc, .ExBrTaken, .ExALUOp, .ExImm12Ext, .ExImm9Ext, 
							 .WbMemDataToReg(WbDataToReg), .MemALUOut, .ForwardDa, .ForwardDb, .ExFwdDb, .ExALUOut, .ExOverflow, .ExNegative, .ExZero, .ExCarryout);
	
	/*-------------------*/
	
	/*--- Exec -> Mem Register	---
	 *
	 * Input:  ExMem2Reg, ExBrTaken, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExAa, ExAb, ExAw, ExFwdDb, ExImmBranch, ExALUOut
	 * Output: MemMem2Reg, MemBrTaken, MemRegWrite, MemMemWrite, MemMemRead,
	 *			  MemRn, MemRm, MemRd, MemDb, MemImmBranch, MemALUOut
	 *
	 */
	 
	logic 		 MemReg2Write, MemMemWrite, MemMemRead;
	
	ExecRegister theExReg (.clk, .reset, 
								  .ExMem2Reg, .ExBrTaken, .ExRegWrite, .ExMemWrite, 
								  .ExMemRead, .ExRn(ExAa), .ExRm(ExAb), .ExRd(ExAw), .ExDb(ExFwdDb), .ExImmBranch, .ExALUOut,
								  
								  .MemMem2Reg, .MemBrTaken, .MemRegWrite, .MemMemWrite, 
								  .MemMemRead, .MemRn, .MemRm, .MemRd, .MemDb, .MemImmBranch, .MemALUOut
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
	 * Input:  MemRd, MemALUOut, MemMem2Reg, MemRegWrite, MemOut
	 * Output: WbRd, WbALUOut, WbMem2Reg, WbRegWrite, WbData
	 *
	 */
	 
	logic [63:0] WbALUOut, WbData;
	logic [1:0]  WbMem2Reg;
	MemoryRegister theMemReg(.clk, .reset, 
							 .MemRd, .MemALUOut, .MemMem2Reg, .MemRegWrite, .MemOut, 

							 .WbRd, .WbALUOut, .WbMem2Reg, .WbRegWrite, .WbData);
	
	/*-------------------*/
	
	/*--- Execute Stage ---
	 *
	 * Input:  WbALUOut, WbData, WbMem2Reg
	 *
	 * Output: WbDataToReg
	 */
	 
	WriteBack theWbStage(.clk, .reset, .MemOutput(WbData), .ALUOutput(WbALUOut), .Mem2Reg(WbMem2Reg), .WbDataToReg);
	
	/*---------------------*/

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
		for (i = 0; i < 500; i++) begin
			@(posedge clk);
		end
		$stop;
	end	
endmodule
