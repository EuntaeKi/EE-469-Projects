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
	logic [63:0] MemALUOut, MemBranchPC, MemDb, DecDb, DecBranchPC;
	logic [1:0]  DecBrTaken;
	logic [1:0]  MemBrTaken, MemMem2Reg;
	InstructionFetch theFetchStage (.Instruction(FetchInst), .currentPC(FetchPC), .branchAddress(DecBranchPC), .Db(MemALUOut), .brTaken(DecBrTaken), .clk, .reset);
	
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
	logic [1:0] DecALUSrc, DecMem2Reg;
   	logic 		DecReg2Loc, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, DecUncondBr, DecFlagWrite;
	logic       ExOverflow, ExNegative, ExZero, ExCarryout;
	logic		InstZero, BLTBrTaken;

	ControlSignal theControlSignals (.Instruction(DecInst), .ALUOp(DecALUOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), .BrTaken(DecBrTaken),
												.Reg2Loc(DecReg2Loc), .Reg2Write(DecReg2Write), .RegWrite(DecRegWrite), .MemWrite(DecMemWrite), .MemRead(DecMemRead), 
												.UncondBr(DecUncondBr), .NegativeFlag(ExNegative), .OverflowFlag(ExOverflow), .ZeroFlag(InstZero), .FlagWrite(DecFlagWrite),
												.BLTBrTaken);
	/*----------------------*/
	
	/*--- Forwarding Unit ---
	 *
	 * Input: ExAa, ExAb, ExAw, MemRegWrite, MemRd, WbRegWrite, WbRd
	 * Output: ForwardDa, ForwardDb
	 */
	logic [4:0] ExAa, ExAb, ExAw, MemRn, MemRm, MemRd, WbRd;
	logic [1:0] ForwardDa, ForwardDb;
	logic		MemRegWrite, WbRegWrite;
	ForwardingUnit theFwdUnit (.ExAa, .ExAb, .ExAw, .MemRd, .WbRd, .MemRegWrite, .WbRegWrite, .ForwardDa, .ForwardDb);
	
	/*----------------------*/
	
	/*--- Decode Stage ---
	 *
	 * Input:  DecPC, DecInst, DecReg2Loc, DecReg2Write, DecUncondBr, WbMemDataToReg, WbRegWrite
	 * Output: DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecBranchPC
	 */
	logic [63:0] DecDa, DecImm12Ext, DecImm9Ext;
	logic [4:0]  DecAa, DecAb, DecAw;
	logic [63:0] WbDataToReg;
	
	InstructionDecode theDecStage (.clk, .reset, .DecPC, .DecInst, .DecReg2Loc, .DecReg2Write, .DecUncondBr, .WbMemDataToReg(WbDataToReg), .WbRegWrite, .WbRd,
											 .DecAa, .DecAb, .DecAw, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext, .DecBranchPC);
	
	// Check if Db is zero for CBZ
	nor_64 CheckDbForZero (.in(DecDb), .out(InstZero));

	/*-------------------*/
	
	/*--- Dec -> Exec Register	---
	 *
	 * Input:  DecPC, DecALUOp, DecALUSrc, DecMem2Reg, DecBrTaken, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, 
	 *			  DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext
	 * Output: ExPC, ExALUOp, ExALUSrc, ExMem2Reg, ExBrTaken, ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExAa, ExAb, ExAw, ExDa, ExDb, ExImm12Ext, ExImm9Ext
	 *
	 */
	logic [63:0] ExPC, ExDa, ExDb, ExImm12Ext, ExImm9Ext;
	logic [31:0] ExcInst;
	logic [2:0]  ExALUOp;
	logic [1:0]  ExALUSrc, ExMem2Reg;
   	logic 		 ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead, ExFlagWrite;
	
	DecodeRegister theDecReg (.clk, .reset,
				 .DecPC, .DecALUOp, .DecALUSrc, .DecMem2Reg, 
				 .DecReg2Write, .DecRegWrite, .DecMemWrite, .DecMemRead, .DecFlagWrite,
				 .DecAa, .DecAb, .DecAw, .DecDa, .DecDb, .DecImm12Ext, .DecImm9Ext,
				  
				 .ExPC, .ExALUOp, .ExALUSrc, .ExMem2Reg, 
				 .ExReg2Write, .ExRegWrite, .ExMemWrite, .ExMemRead, .ExFlagWrite,
				 .ExAa, .ExAb, .ExAw, .ExDa, .ExDb, .ExImm12Ext, .ExImm9Ext);
	/*----------------------*/

	/*--- Execute Stage ---
	 *
	 * Input:  ExPC, ExDa, ExDb, ExALUSrc, ExBrTaken, ExALUOp, ExImm12Ext, ExImm9Ext
	 *			  WbData, MemALUOut, ForwardDa, ForwardDb
	 *
	 * Output: ExBranchPC, ExFwdDb, ExALUOut, ExOverflow, ExNegative, ExZero, ExCarryout
	 */
	 
	logic [63:0] ExALUOut, ExFwdDb;
	
	Execute theExStage(.clk, .reset, .ExPC, .ExDa, .ExDb, .ExALUSrc, .ExALUOp, .ExFlagWrite, .ExImm12Ext, .ExImm9Ext,
							 .WbMemDataToReg(WbDataToReg), .MemALUOut, .ForwardDa, .ForwardDb, .ExFwdDb, .ExALUOut,
							.ExOverflow, .ExNegative, .ExZero, .ExCarryout, .BLTBrTaken);
	
	/*-------------------*/
	
	/*--- Exec -> Mem Register	---
	 *
	 * Input:  ExPC, ExMem2Reg, ExBrTaken, ExRegWrite, ExMemWrite, ExMemRead,
	 *			  ExAa, ExAb, ExAw, ExFwdDb, ExBranchPC, ExALUOut
	 * Output: MemPC, MemMem2Reg, MemBrTaken, MemRegWrite, MemMemWrite, MemMemRead,
	 *			  MemRn, MemRm, MemRd, MemDb, MemBranchPC, MemALUOut
	 *
	 */
	logic [63:0] MemPC; 
	logic 		 MemReg2Write, MemMemWrite, MemMemRead;
	
	ExecRegister theExReg (.clk, .reset, 
								  .ExPC, .ExMem2Reg, .ExRegWrite, .ExMemWrite, 
								  .ExMemRead, .ExRn(ExAa), .ExRm(ExAb), .ExRd(ExAw), .ExDb(ExFwdDb), .ExALUOut,
								  
								  .MemPC, .MemMem2Reg, .MemRegWrite, .MemMemWrite, 
								  .MemMemRead, .MemRn, .MemRm, .MemRd, .MemDb, .MemALUOut
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
	 
	logic [63:0] WbPC, WbALUOut, WbData;
	logic [1:0]  WbMem2Reg;
	MemoryRegister theMemReg(.clk, .reset, 
							 .MemPC, .MemRd, .MemALUOut, .MemMem2Reg, .MemRegWrite, .MemOut, 

							 .WbPC, .WbRd, .WbALUOut, .WbMem2Reg, .WbRegWrite, .WbData);
	
	/*-------------------*/
	
	/*--- Execute Stage ---
	 *
	 * Input:  WbPC, WbALUOut, WbData, WbMem2Reg
	 *
	 * Output: WbDataToReg
	 */
	 
	WriteBack theWbStage(.clk, .reset, .MemOutput(WbData), .ALUOutput(WbALUOut), .WbPC, .Mem2Reg(WbMem2Reg), .WbDataToReg);
	
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
		for (i = 0; i < 100; i++) begin
			@(posedge clk);
		end
		$stop;
	end	
endmodule
