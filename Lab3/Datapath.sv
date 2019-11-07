`timescale 1ns/10ps
module CPUdatapath (clk, reset, Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite, MemToReg, Instruction, foverflow, fnegative, fzero, fcout);
	// Input Logic
	input  logic        clk, reset;
	input  logic        Reg2Loc, RegWrite, MemWrite, MemToReg;
	input  logic [1:0]  ALUSrc;
	input  logic [2:0]  ALUOp;
	input  logic [31:0] Instruction;
	
	// Output Logic
	output logic        foverflow, fnegative, fzero, fcout;
	
	// Intermediate Logic
	logic [4:0] Ab;
	
	// Rd = Instruction[4:0] when used
	// Rm = Instruction[20:16] when used
	// Db not used if neither are used
	MUX5_2_1 MuxRegToLoc(.A(Instruction[4:0]), .B(Instruction[20:16]), .en(Reg2Loc), .out(Ab[4:0]));
	
endmodule
/*
module CPUdatapath_testbench ();
	parameter N = 13;
	logic [4:0] Rd, Rm, Rn;
	logic [11:0] AddI12;
	logic [2:0] ALUOp;
	logic clk, Reg2Loc, RegWrite, ALUSrc, MemWrite, MemToReg, Zero;
	
	CPUdatapath dut (.*);
	
	initial begin
		clk <= 0;
		forever #50 clk <= ~clk;
	end
	
	integer i;
	initial begin
		Reg2Loc <= 1;	RegWrite <= 0;	ALUSrc <= 0;	ALUOp <= 3'b000;	MemWrite <= 0;	MemToReg <= 0;
		Rm <= 5'b0;	Rn <= 5'b0;	Rd <= 5'd0;	AddI12 <= 12'd0;	@(posedge clk);
		@(posedge clk);
		// Write a value into each  register.
		$display("%t Writing pattern to all registers.", $time);
		for (i=0; i<31; i=i+1) begin
			RegWrite <= 0;
			Rn <= i-1;
			Rm <= i;
			Rd <= i;
			Dw <= i*64'h0000010204080001;
			@(posedge clk);
			
			RegWrite <= 1;
			@(posedge clk);
		end
		@(posedge clk);
		RegWrite <= 0;	ALUSrc <= 1;	ALUOp <= 3'b010;	Rm <= 5'd0;	Rn <= 5'd10;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule*/