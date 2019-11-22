`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;
	
	/*** Instruction Fetch Stage ***/
	logic [63:0] IFPC;
	logic [31:0] IFInst;
	InstructionFetch theFetchStage (.instruction(IFInst), .currentPc(IFPC), .branchAddress(nextPc), .brTaken(takeBranch), .clk, .reset);
	/*----------------------------*/
	
	// IF -> ID Setup
	logic [63:0] IDPC;
	logic [31:0] IDInst;
	InstructionRegister theInstReg (.IFPC, .IFInst, .IDPC, .IDInst, .clk, .reset);
	
	/*** Decode Stage ***/
	logic [63:0] DecDa, DecDb;
	InstructionDecode theDecStage(.clk, .reset, .Reg2Loc, .RegWrite, .ALUSrc, .Dw, .Instruction, .DecDa, .DecDb, .DecMemAddr9Ext, .DecImm12Ext);
	/*------------------*/
	
	// ID -> Exec Setup
	ControlSignal theControlSignals();
	ForwardingUnit theForwardingUnit();

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
