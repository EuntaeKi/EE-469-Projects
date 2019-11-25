`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;
	
	/*** Instruction Fetch Stage ***/
	logic [63:0] FetchPC;
	logic [31:0] FetchInst;
	InstructionFetch theFetchStage (.Instruction(FetchInst), .currentPC(FetchPC), .branchAddress(nextPC), .brTaken(takeBranch), .clk, .reset);
	/*----------------------------*/
	
	// Fetch -> Dec Setup
	logic [63:0] DecPC;
	logic [31:0] DecInst;
	InstructionRegister theInstReg (.FetchPC, .FetchInst, .DecPC, .DecInst, .clk, .reset);
	
	/*** Decode Stage ***/
	logic [63:0] DecDa, DecDb, DecMemAddr9Ext, DecImm12Ext;
	logic [4:0] DecAa, DecAb, DecAw;
	InstructionDecode theDecStage(.clk, .reset, .DecReg2Loc, .DecRegWrite(WbRegWrite), .DecReg2Write, .DecDw(WbOutput), .Instruction(DecInst), .DecDa, .DecDb, .DecAb, .DecAw, .DecMemAddr9Ext, .DecImm12Ext);
	/*------------------*/
	
	// ID -> Exec Setup
	logic [2:0] DecALUOp;
	logic [1:0] DecBrTaken, DecALUSrc, DecMem2Reg;
	logic 		DecReg2Loc, UncondBr, DecReg2Write, DecRegWrite;
	logic		DecFlagWrite, DecMemWrite, DecMemRead;
	logic		ExZero, ExNegative, ExOverflow, ExCout;
	ControlSignal theControlSignals(.Instruction(DecInst), .ALUOp(DecALUOp), .ALUSrc(DecALUSrc), .Mem2Reg(DecMem2Reg), .BrTaken(DecBrTaken),
									.Reg2Loc(DecReg2Loc), .Reg2Write(DecReg2Write), .RegWrite(DecRegWrite), .MemWrite(DecMemWrite), .MemRead(DecMemRead), .UncondBr, 
									.FlagWrite(DecFlagWrite), .NegativeFlag(ExNegative), .CoutFlag(ExCout), .OverflowFlag(ExOverflow), .ZeroFlag(ExZero), .ALUZero(ExZeroInst));
	
	/********************
	//ForwardingUnit	theForwadingUnit(.ForwardDa, .ForwardDb, .DecRd, .DecRm, .DecRn, .MemRegWrite, .MemRd, .WbRegWrite, .WbRd);
	*********************/
	
	logic [63:0] ExDa, ExDb, ExMemAddr9Ext, ExImm12Ext;
	logic [2:0]  ExALUOp;
	logic [1:0]  ExMem2Reg, ExALUSrc;
	logic        ExMemWrite, ExMemRead, ExFlagWrite, ExRegWrite;
	DecodeRegister theDecReg(.clk, .reset, .DecDa, .DecDb, .DecALUOp, .DecMem2Reg, .DecMemWrite, .DecMemRead, .DecFlagWrite, .DecRegWrite, .DecMemAddr9Ext, .DecImm12Ext,
							 .ExDa, .ExDb, .ExALUOp, .ExMem2Reg, .ExMemWrite, .ExMemRead, .ExFlagWrite, .ExRegWrite, .ExMemAddr9Ext, .ExImm12Ext);
	

	/*** Exectue Stage ***/
	logic [63:0] ExALUOutput;
	logic        ExZeroInst;	// Used in ControlSignal?
	// Need to clean up the flag signals
	Execute theExStage(.clk, .reset, .ExDa, .ExDb, .ExALUOp, .ExALUSrc, .ExFlagWrite, .ExMemAddr9Ext, .ExImm12Ext, 
						.ExNegative, .ExCout, .ExOverflow, .ExZero, .ExZeroInst, .ExALUOutput);
	/*-------------------*/
	
	// Exec -> Mem Setup
	logic [63:0] MemDb, MemALUOutput;
	logic [1:0]	 MemMem2Reg;
	logic 		 MemMemWrite, MemMemRead, MemRegWrite;
	ExecRegister theExReg(.clk, .reset, .ExDb, .ExALUOutput, .ExMem2Reg, .ExMemWrite, .ExMemRead, .ExRegWrite, 
							.MemDb, .MemALUOutput, .MemMem2Reg, .MemMemWrite, .MemMemRead, .MemRegWrite);
	
	/*** Memory Stage ***/
	logic [63:0] nextPC, MemOutput;
	logic 		 takeBranch;
	Memory theMemStage(.clk, .reset, .address(MemALUOutput), .MemWrite(MemMemWrite), .MemRead(MemMemRead), .MemWriteData(MemDb), .MemOutput);
	/*------------------*/
	
	// Mem -> Wb Setup
	logic [63:0] WbMemOutput, WbALUOutput;
	logic [1:0]  WbMem2Reg;
	logic 		 WbRegWrite;
	MemoryRegister theMemReg(.clk, .reset, .MemOutput, .MemALUOutput, .MemMem2Reg, .MemRegWrite, .WbMemOutput, .WbALUOutput, .WbMem2Reg, .WbRegWrite);
	
	/*** WriteBack Stage ***/
	logic [63:0] WbOutput;
	WriteBack theWbStage(.clk, .reset, .MemOutput(WbMemOutput), .ALUOutput(WbALUOutput), .Mem2Reg(WbMem2Reg), .WbOutput);
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
