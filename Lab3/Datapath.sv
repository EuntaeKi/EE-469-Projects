`timescale 1ns/10ps
module CPUdatapath (clk, reset, Reg2Loc, RegWrite, ALUSrc, ALUOp, MemRead, MemWrite, MemToReg, Instruction, XferSize, foverflow, fnegative, fzero, fcout);
	// Input Logic
	input  logic        clk, reset;
	input  logic        Reg2Loc, RegWrite, MemRead, MemWrite, MemToReg;
	input  logic [1:0]  ALUSrc;
	input  logic [2:0]  ALUOp;
	input  logic [3:0]  XferSize;
	input  logic [31:0] Instruction;
	
	// Output Logic
	output logic        foverflow, fnegative, fzero, fcout;
	
	// Intermediate Logic
	logic [4:0]  Ab;
	logic [63:0] Da, Db, Dw, Imm12_Ext, Imm9_Ext, ALUB, ALUOut, MemOut;
	
	// Reg2Loc Mux
	// Rd = Instruction[4:0] when used
	// Rm = Instruction[20:16] when used
	// Otherwise value is not used
	mux2to1_Nbit MuxReg2Loc #(.N(5)) (.A(Instruction[4:0]), .B(Instruction[20:16]), .en(Reg2Loc), .out(Ab[4:0]));
	
	// Imm12
	// Zero Extended Instruction[21:10] when used
	// Otherwise value is not used
	ZeroExtend ExtendImm12 #(.N(12)) (.in(Instruction[21:10]), .out(Imm12_Ext));
	
	// Imm9
	// Sign Extended Instruction[20:12] when used
	// Otherwise value is not used
	SignExtend ExtendImm9 #(.N(9)) (.in(Instruction[20:12]), .out(Imm9_Ext));
	
	// RegFile
	// Rn = Instruction[9:5] when used
	// Otherwise value is not used
	regfile Register (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(Instruction[9:5]), .ReadRegister2(Ab));
	
	// ALUSrc Mux
	mux4to1_64bit MuxALUSrc(.select(ALUSrc), .in({64'bx, Imm9_Ext, Imm12_Ext, Db}, .out(ALUB));
	
	// ALU
	alu TheAlu (.A(Da), .B(ALUB), .cntrl(ALUOp), .result(ALUOut), .negative(fnegative), .zero(fzero), .overflow(foverflow), .carry_out(fcout));
	
	// Data Memory
	datamem DataMemory (.address(ALUOut), .write_enable(MemWrite), .read_enable(MemRead), .write_data(Db), .clk(clk), .xfer_size(XferSize), .read_data(MemOut));
	
	// MemToReg Mux
	mux2to1_Nbit MuxMemToReg #(.N(64)) (.A(ALUOut), .B(MemOut), .en(MemToReg), .out(Dw));
	
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