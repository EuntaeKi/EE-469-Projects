`timescale 1ns/10ps

module CPU (CLOCK_50, reset);
	// Input Logic
	input logic CLOCK_50, reset;
	
	// Divided Clock
	logic [31:0] divided_clocks;
	
	// Control Signal logics
	logic [63:0] Db, NextPC;
	logic [31:0] Instruction;
	logic [2:0] ALUOp;
	logic [1:0] ALUSrc, MemToReg, BrTaken;
	logic Reg2Loc, Reg2Write, RegWrite, MemWrite, MemRead, UncondBr, UpdateFlag, fzero, foverflow, fnegative, fcout;

	clockDivider clock (.clk(CLOCK_50), .divided_clocks);
	ControlSignal signal (.Instruction, .Reg2Loc, .Reg2Write, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .MemRead, .BrTaken, .UncondBr, .ALUOp, .UpdateFlag, .fzero, .foverflow, .fnegative, .fcout);
	InstructionFetch instFetch (.clk(divided_clocks[5]), .reset, .Db, .UncondBr, .BrTaken, .Instruction, .NextPC);
	Datapath data (.clk(divided_clocks[5]), .reset, .Reg2Loc, .Reg2Write, .RegWrite, .ALUSrc, .ALUOp, .MemWrite, .MemRead, .MemToReg, .Instruction, .NextPC, .UpdateFlag, .XferSize(4'b1000), .Db, .foverflow, .fnegative, .fzero, .fcout);

endmodule 

module cpu_tb();
	logic clk, reset;
	
	CPU dut (.CLOCK_50(clk), .reset(reset));
	
	parameter CLOCK_PERIOD = 1000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	int i;
	initial begin
		reset = 1; @(posedge clk);
		reset = 0;
		for (i = 0; i < 100; i++) begin
			@(posedge clk);
		end
		$stop;
	end	
endmodule
