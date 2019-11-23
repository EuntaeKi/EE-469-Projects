`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;
	
	/*** Instruction Fetch Stage ***/
	logic [63:0] FetchPC;
	logic [31:0] FetchInst;
	InstructionFetch theFetchStage (.instruction(FetchInst), .currentPc(FetchPC), .branchAddress(nextPc), .brTaken(takeBranch), .clk, .reset);
	/*----------------------------*/
	
	// Fetch -> Dec Setup
	logic [63:0] DecPC;
	logic [31:0] DecInst;
	InstructionRegister theInstReg (.FeatchPC, .FetchInst, .DecPC, .DecInst, .clk, .reset);
	
	/*** Decode Stage ***/
	logic [63:0] DecDa, DecDb;
	InstructionDecode theDecStage(.clk, .reset, .Reg2Loc, .RegWrite, .DecALUSrc, .Dw, .Instruction, .DecDa, .DecDb, .DecMemAddr9Ext, .DecImm12Ext);
	/*------------------*/
	
	// ID -> Exec Setup
	logic [2:0] DecALUOp;
	logic [1:0] DecBrTaken, DecALUSrc, DecMem2Reg;
	logic 		Reg2Loc, UncondBr, DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, DecBrTaken, DecFlagWrite;
	logic			ExZero, ExNeg, ExOverflow, ExCout;
	ControlSignal theControlSignals(.Instruction(DecInst), .ALUOp(DecALIOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), .BrTaken(DecBrTaken),
													.Reg2Loc, .Reg2Write(DecReg2Write), .RegWrite(DecRegWrite), .MemWrite(DecMemWrite), .MemRead(DecMemRead),
														.UncondBr, .FlagWrite(DecFlagWrite), .NegativeFlag(ExNeg), .CoutFlag(ExCout), .OverflowFlag(ExOVerflow), .ZeroFlag(ExZero));
	
	ForwardingUnit	theForwadingUnit(.ForwardDa, .ForwardDb, .DecRd, .DecRm, .DecRn, .MemRegWrite, .MemRd, .WbRegWrite, .WbRd);
														
	logic [63:0] ExDa, ExDb, ExMemAddr9Ext, ExImm12Ext;
	DecodeRegister theDecReg(.clk, .reset, .DecDa, .DecDb, .ExDa, .ExDb, .DecMemAddr9Ext, .DecImm12Ext, .ExMemAddr9Ext, .ExImm12Ext);
	
	/*** Exectue Stage ***/
	Execute theExStage();
	/*-------------------*/
	
	// Exec -> Mem Setup
	ExecRegister theExReg();
	
	/*** Memory Stage ***/
	logic [63:0] nextPc;
	logic 		 takeBranch;
	Memory theMemStage();
	/*------------------*/
	
	// Mem -> Wb Setup
	MemoryRegister theMemReg();
	
	/*** WriteBack Stage ***/
	WriteBack theWbStage();
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
