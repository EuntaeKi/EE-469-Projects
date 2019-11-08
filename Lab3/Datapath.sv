`timescale 1ns/10ps
module Datapath (clk, reset, Reg2Loc, Reg2Write, RegWrite, ALUSrc, ALUOp, MemWrite, MemRead, MemToReg, Instruction, NextPC, UpdateFlag, XferSize, Db, foverflow, fnegative, fzero, czero, fcout);
	// Input Logic
	input  logic        clk, reset;
	input  logic        Reg2Loc, Reg2Write, RegWrite, MemWrite, MemRead, UpdateFlag;
	input  logic [1:0]  ALUSrc, MemToReg;
	input  logic [2:0]  ALUOp;
	input  logic [3:0]  XferSize;
	input  logic [31:0] Instruction;
	input  logic [63:0] NextPC;
	
	// Output Logic
	output logic        foverflow, fnegative, fzero, fcout, czero;
	output logic [63:0] Db;
	
	// Intermediate Logic
	logic        overflow, negative, zero, cout;
	logic [4:0]  Aw, Ab;
	logic [63:0] Da, Dw, Imm12_Ext, Imm9_Ext, ALUB, ALUOut, MemOut;
	
	// Reg2Write Mux
	// Rm = Instruction[4:0] when used
	mux2to1_Nbit #(.N(5)) MuxReg2Write (.en(Reg2Write), .a(Instruction[4:0]), .b(5'd30), .out(Aw[4:0]));
	
	// Reg2Loc Mux
	// Rd = Instruction[4:0] when used
	// Rm = Instruction[20:16] when used
	// Otherwise value is not used
	mux2to1_Nbit #(.N(5)) MuxReg2Loc (.en(Reg2Loc), .a(Instruction[4:0]), .b(Instruction[20:16]), .out(Ab[4:0]));
	
	// Imm12
	// Zero Extended Instruction[21:10] when used
	// Otherwise value is not used
	SignExtend #(.N(13)) ExtendImm12 (.in({1'b0, Instruction[21:10]}), .out(Imm12_Ext));
	
	// Imm9
	// Sign Extended Instruction[20:12] when used
	// Otherwise value is not used
	SignExtend #(.N(9)) ExtendImm9 (.in(Instruction[20:12]), .out(Imm9_Ext));
	
	// RegFile
	// Rn = Instruction[9:5] when used
	// Otherwise value is not used
	regfile Register (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(Instruction[9:5]), .ReadRegister2(Ab), .WriteRegister(Aw), .RegWrite(RegWrite), .clk(clk));
	
	// ALUSrc Mux
	mux4to1_64bit MuxALUSrc(.select(ALUSrc), .in({64'bx, Imm9_Ext, Imm12_Ext, Db}), .out(ALUB));
	
	// ALU
	alu TheAlu (.A(Da), .B(ALUB), .cntrl(ALUOp), .result(ALUOut), .negative(negative), .zero(zero), .overflow(overflow), .carry_out(cout));
	
	// Flag Register
	// cZero flag is updated immediately - others update with the clock.
	FlagReg TheFlagRegister (.clk(clk), .reset(reset), .enable(UpdateFlag), .in({negative, cout, overflow, zero}), .out({fnegative, fcout, foverflow, fzero}));
	assign czero = zero;
	
	// Data Memory
	datamem DataMemory (.address(ALUOut), .write_enable(MemWrite), .read_enable(MemRead), .write_data(Db), .clk(clk), .xfer_size(XferSize), .read_data(MemOut));
	
	// MemToReg Mux
	mux4to1_64bit MuxMemToReg (.select(MemToReg[1:0]), .in({64'bx, NextPC, MemOut, ALUOut}), .out(Dw));
	
endmodule 