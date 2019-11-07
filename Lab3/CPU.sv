`timescale 1ns/10ps

module CPU (clk, reset);
	// Input Logic
	input logic clk, reset;
	
	// Divided Clock
	//logic [31:0] divided_clocks;
	
	// Control Signal logics
	logic [63:0] Db, NextPC;
	logic [31:0] Instruction;
	logic [2:0] ALUOp;
	logic [1:0] ALUSrc, MemToReg, BrTaken;
	logic Reg2Loc, Reg2Write, RegWrite, MemWrite, MemRead, UncondBr, UpdateFlag, fzero, foverflow, fnegative, fcout;

	//clockDivider clock (.clk(clk), .divided_clocks);
	ControlSignal signal (.Instruction, .Reg2Loc, .Reg2Write, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .MemRead, .BrTaken, .UncondBr, .ALUOp, .UpdateFlag, .fzero, .foverflow, .fnegative, .fcout);
	InstructionFetch instFetch (.clk(clk), .reset, .Db, .UncondBr, .BrTaken, .Instruction, .NextPC);
	Datapath data (.clk(clk), .reset, .Reg2Loc, .Reg2Write, .RegWrite, .ALUSrc, .ALUOp, .MemWrite, .MemRead, .MemToReg, .Instruction, .NextPC, .UpdateFlag, .XferSize(4'b1000), .Db, .foverflow, .fnegative, .fzero, .fcout);

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
		reset = 0; @(posedge clk); @(posedge clk);
		for (i = 0; i < 100; i++) begin
			@(posedge clk);
		end
		$stop;
	end	
endmodule
