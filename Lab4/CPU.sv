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
	InstructionFetch theFetchStage (.Instruction(FetchInst), .currentPC(FetchPC), .branchAddress(MemBrPC), .clk, .reset);
	
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
	
	ControlSignal theControlSignals (.Instruction(DecInst), .ALUOp(DecALUOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), .BrTaken(DecBrTaken),
												.Reg2Loc(DecReg2Loc), .Reg2Write(DecReg2Write), .RegWrite(DecRegWrite), .MemWrite(DecMemWrite), .MemRead(DecMemRead), 
												.UncondBr(DecUncondBr), .NegativeFlag(ExNegative), .OverflowFlag(ExOverflow), .ZeroFlag(ExZero));
	/*----------------------*/
	
	/*--- Forwarding Unit ---
	 *
	 * Input: ExRn, ExRm, ExRd, MemRegWrite, MemRd, WbRegWrite, WbRd
	 * Output: ForwardDa, ForwardDb
	 */
	 
	logic [1:0] ForwardDa, ForwardDb;
	ForwardingUnit theFwdUnit (.ExRn, .ExRm, .ExRd, .MemRd, .WbRd, .MemRegWrite, .WbRegWrite, .ForwardDa, .ForwardDb);
	
	/*----------------------*/
	
	/*--- Decode Stage ---
	 *
	 * Input:  DecInst, DecReg2Loc, DecUncondBr, WbMemDataToReg, WbRegWrite
	 * Output: DecRn, DecRm, DecRd, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch
	 */
	logic [63:0] DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch;
	logic [4:0]  DecRn, DecRm, DecRd;
	 
	InstructionDecode theDecStage (.clk, .reset, .DecInst, .DecReg2Loc, .DecUncondBr, .WbMemDataToReg, .WbRegWrite, 
											 .DecRn, .DecRm, .DecRd, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext, 
											 .DecImmBranch);
	/*-------------------*/
	
	/*--- Dec -> Exec Register	---
	 *
	 * Input:  DecPC, DecALUOp, DecALUSrc, DecMem2Reg, DecBrTaken, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, 
	 *			  DecRn, DecRm, DecRd, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch
	 * Output: ExPC, ExALUOp, ExALUSrc, ExMem2Reg, ExBrTaken, ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExRn, ExRm, ExRd, ExDa, ExDb, ExImm12Ext, ExImm9Ext, ExImmBranch
	 *
	 */
	logic [63:0] ExPC, ExDa, ExDb, ExImm12Ext, ExImm9Ext, ExImmBranch;
	logic [31:0] ExcInst;
	logic [4:0]  ExRn, ExRm, ExRd;
	logic [2:0]  ExALUOp;
	logic [1:0]  ExBrTaken, ExALUSrc, ExMem2Reg;
   	logic 		 ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead;
	
	DecodeRegister theDecReg (.clk, .reset,
				 .DecPC, .DecALUOp, .DecALUSrc, .DecMem2Reg, .DecBrTaken, 
				 .DecReg2Write, .DecRegWrite, .DecMemWrite, .DecMemRead, .DecRn, 
				 .DecRm, .DecRd, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext, .DecImmBranch,
				  
				 .ExPC, .ExALUOp, .ExALUSrc, .ExMem2Reg, .ExBrTaken, 
				 .ExReg2Write, .ExRegWrite, .ExMemWrite, .ExMemRead, .ExRn, 
				 .ExRm, .ExRd, .ExDa, .ExDb, .ExImm12Ext, .ExImm9Ext, .ExImmBranch);
	/*----------------------*/

	/*--- Execute Stage ---
	 *
	 * Input:  ExDa, ExDb, ExALUSrc, ExBrTaken, ExALUOp, ExPC, ExImm12Ext, ExImm9Ext, ExImmBranch
	 *			  WbData, MemALUOut, ForwardDa, ForwardDb
	 *
	 * Output: ExBrPC, ExALUOut, ExOverflow, ExNegative, ExZero, ExCarryout
	 */
	 
	logic [63:0] ExBrPC, ExALUOut;
	logic        ExOverflow, ExNegative, ExZero, ExCarryout;
	
	Execute theExStage(.clk, .reset, .ExDa, .ExDb, .ExALUSrc, .ExBrTaken, .ExALUOp, .ExPC, .ExImm12Ext, .ExImm9Ext, 
							 .ExImmBranch, .WbDataToReg, .MemALUOut, .ForwardDa, .ForwardDb,
							 .ExBrPC, .ExALUOut, .ExOverflow, .ExNegative, .ExZero, .ExCarryout);
	
	/*-------------------*/
	
	/*--- Exec -> Mem Register	---
	 *
	 * Input:  ExMem2Reg, ExBrTaken, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExRn, ExRm, ExRd, ExDb, ExBrPC, ExALUOut
	 * Output: MemMem2Reg, MemBrTaken, MemRegWrite, MemMemWrite, MemMemRead,
	 *			  MemRn, MemRm, MemRd, MemDb, MemBrPC, MemALUOut
	 *
	 */
	 
	logic [63:0] MemDb, MemALUOut, MemBrPC;
	logic [4:0]  MemRn, MemRm, MemRd;
	logic [1:0]  MemBrTaken, MemMem2Reg;
	logic 		 MemReg2Write, MemRegWrite, MemMemWrite, MemMemRead;
	
	ExecRegister theExReg (.clk, .reset, 
								  .ExMem2Reg, .ExBrTaken, .ExRegWrite, .ExMemWrite, 
								  .ExMemRead, .ExRn, .ExRm, .ExRd, .ExDb, .ExBrPC, .ExALUOut,
								  
								  .MemMem2Reg, .MemBrTaken, .MemRegWrite, .MemMemWrite, 
								  .MemMemRead, .MemRn, .MemRm, .MemRd, .MemDb, .MemBrPC, .MemALUOut
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
	 * Input:  MemRd, MemALUOut, MemMem2Reg, MemRegWrite, MemData
	 * Output: WbRd, WbALUOut, WbMem2Reg, WbRegWrite, WbData
	 *
	 */
	 
	logic [63:0] WbALUOut, WbData;
	logic [4:0]  WbRd;
	logic [1:0]  WbMem2Reg;
	logic 		 WbRegWrite;
	MemoryRegister theMemReg(.clk, .reset, 
							 .MemRd, .MemALUOut, .MemMem2Reg, .MemRegWrite, .MemData, 

							 .WbRd, .WbALUOut, .WbMem2Reg, .WbRegWrite, .WbData);
	
	/*-------------------*/
	
	/*--- Execute Stage ---
	 *
	 * Input:  WbALUOut, WbData, WbMem2Reg
	 *
	 * Output: WbDataToReg
	 */
	 
	logic [63:0] WbDataToReg;
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
