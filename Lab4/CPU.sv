`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;

	// Control Signals
	logic [31:0] Instruction;
	logic [2:0]  ALUOp;
	logic [1:0]  ALUSrc, Mem2Reg, BrTaken;
	logic 		 Reg2Loc, Reg2Write, RegWrite, MemWrite, MemRead, UncondBr;

	// Flag Signals
	logic        FlagWrite, NegativeFlag, CoutFlag, OverflowFlag, ZeroFlag;

	// Logic passed between modules
	logic [63:0] Db, NoBranchPC;
	logic 		 ALUZero;
	
	InstructionFetch instFetch (.clk, .reset, .Instruction, 
											.BrTaken, .UncondBr, .Db, .NoBranchPC);
	
	ControlSignal signal (.Instruction, .ALUOp, .ALUSrc, .Mem2Reg, .BrTaken, 
									.Reg2Loc, .Reg2Write, .RegWrite, .MemWrite, .MemRead, .UncondBr, 
										.FlagWrite, .NegativeFlag, .CoutFlag, .OverflowFlag, .ZeroFlag, .ALUZero);
										
	Datapath data (.clk, .reset, .Instruction, .ALUOp, .ALUSrc, .Mem2Reg, .Reg2Loc,
							.Reg2Write, .RegWrite, .MemWrite, .MemRead, .FlagWrite, .NegativeFlag, 
								.CoutFlag, .OverflowFlag, .ZeroFlag, .ALUZero, .Db, .NoBranchPC, .XferSize(4'b1000));

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
