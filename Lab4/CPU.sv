`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;
	
	/*** Instruction Fetch Stage ***/
	logic [63:0] FetchPC;
	logic [31:0] FetchInst;
	InstructionFetch theFetchStage (.instruction(FetchInst), .currentPc(FetchPC), .branchAddress(nextPC), .brTaken(takeBranch), .clk, .reset);
	/*----------------------------*/
	
	// Fetch -> Dec Setup
	logic [63:0] DecPC;
	logic [31:0] DecInst;
	InstructionRegister theInstReg (.FeatchPC, .FetchInst, .DecPC, .DecInst, .clk, .reset);
	
	/*** Decode Stage ***/
	logic [63:0] DecDa, DecDb, DecMemAddr9Ext, DecImm12Ext;
	logic [4:0] DecAa, DecAb, DecAw;
	InstructionDecode theDecStage(.clk, .reset, .DecReg2Loc, .DecRegWrite, .DecReg2Write, .DecALUSrc, .DecDw, .Instruction(IDInst), .DecDa, .DecDb, .DecAb, .DecAw, .DecMemAddr9Ext, .DecImm12Ext);
	/*------------------*/
	
	// ID -> Exec Setup
	logic [2:0] ExALUOp;
	logic [1:0] DecBrTaken, DecALUSrc, DecMem2Reg;
	logic 		DecReg2Loc, UncondBr, DecReg2Write, DecRegWrite, DecBrTaken;
	logic		ExFlagWrite, ExZero, ExNegative, ExOverflow, ExCout;
	logic		MemWrite, MemRead;
	ControlSignal theControlSignals(.Instruction(DecInst), .ALUOp(ExALUOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), .BrTaken(DecBrTaken),
									.Reg2Loc(DecReg2Loc), .Reg2Write(DecReg2Write), .RegWrite(DecRegWrite), .MemWrite, .MemRead, .UncondBr, 
									.FlagWrite(ExFlagWrite), .NegativeFlag(ExNegative), .CoutFlag(ExCout), .OverflowFlag(ExOverflow), .ZeroFlag(ExZero), .ALUZero(ExZeroInst));
	
	ForwardingUnit	theForwadingUnit(.ForwardDa, .ForwardDb, .DecRd, .DecRm, .DecRn, .MemRegWrite, .MemRd, .WbRegWrite, .WbRd);
														
	logic [63:0] ExDa, ExDb, ExMemAddr9Ext, ExImm12Ext;
	DecodeRegister theDecReg(.clk, .reset, .DecDa, .DecDb, .ExDa, .ExDb, .DecMemAddr9Ext, .DecImm12Ext, .ExMemAddr9Ext, .ExImm12Ext);
	
	/*** Exectue Stage ***/
	logic [63:0] ExALUOutput;
	logic        ExZeroInst;	// Used in ControlSignal?
	Execute theExStage(.clk, .reset, .ExDa, .ExDb, .ExALUOp, .ExFlagWrite, .ExNegative, .ExCout, .ExOverflow, .ExZero, .ExZeroInst, .ExALUOutput);
	/*-------------------*/
	
	// Exec -> Mem Setup
	logic [63:0] ExRegALUOutput, ExRegDecDb;
	ExecRegister theExReg(.clk, .reset, .DecDb, .ExALUOutput, .ExRegDecDb, .ExRegALUOutput);
	
	/*** Memory Stage ***/
	logic [63:0] nextPC, MemOutput;
	logic 		 takeBranch;
	Memory theMemStage(.clk, .reset, .address(ExRegOutput), .MemWrite, .MemRead, .MemWriteData(ExRegDecDb), .MemOutput);
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
