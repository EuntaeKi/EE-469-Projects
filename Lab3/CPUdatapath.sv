`timescale 1ns/10ps
module CPUdatapath (Rd, Rm, Rn, clk, Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite, MemToReg, Zero, AddI12);
	input logic [4:0] Rd, Rm, Rn;
	input logic [11:0] AddI12;
	input logic [2:0] ALUOp;
	input logic clk, Reg2Loc, RegWrite, ALUSrc, MemWrite, MemToReg;
	output logic Zero;	
	parameter N = 13;
	logic [4:0] Ab;
	logic [63:0] Da, Db, Dbb, AddI, aluResult, memResult, Dw;
	logic overflow, carry_out, negative;
	
	MUX64_2_1 AbMUX (.a(Rd), .b(Rm), .en(Reg2Loc), .out(Ab));
		defparam AbMUX.N = 5;
	MUX64_2_1 DbbMUX (.a(Db), .b(AddI), .en(ALUSrc), .out(Dbb));
	MUX64_2_1 DWMUX (.a(aluResult), .b(memResult), .en(MemToReg), .out(Dw));
	
	regfile register (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(Rn), .ReadRegister2(Ab), .WriteRegister(Rd), .RegWrite, .clk);
	alu aluMod (.A(Da), .B(Dbb), .cntrl(ALUOp), .result(aluResult), .negative, .zero(Zero), .overflow, .carry_out);
	signExtend #(.N(N)) signAddi (.in({1'b0, AddI12}), .out(AddI));
	datamem memory (.address(aluResult), .write_enable(MemWrite), .read_enable(1'b1), .write_data(Db), .clk, .xfer_size(4'b1000), .read_data(memResult));
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