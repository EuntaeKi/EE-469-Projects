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
	InstructionDecode theDecStage();
	/*------------------*/
	
	// ID -> Exec Setup
	ControlSignal theControlSignals();
	ForwardingUnit theForwardingUnit();
	ExecRegister theExReg();
	
	/*** Exectue Stage ***/
	Execute theExStage();
	/*-------------------*/
	
	// Exec -> Mem Setup
	logic [63:0] nextPc;
	logic 		 takeBranch;
	MemoryRegister theMemStage();
	
	/*** Memory Stage ***/
	Memory theMemStage();
	/*------------------*/
	
	// Mem -> Wb Setup
	WbRegister theWbReg();
	
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
