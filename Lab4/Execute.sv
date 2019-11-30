`timescale 1ns/10ps

module Execute (clk, reset, 
					ExPC, ExDa, ExDb, ExALUSrc, ExALUOp, ExFlagWrite, ExImm12Ext, ExImm9Ext,
					WbMemDataToReg, MemALUOut, ForwardDa, ForwardDb, ExFwdDb,
					ExALUOut, ExOverflow, ExNegative, ExZero, ExCarryout, BLTBrTaken);
					
   // Input Logic
	input  logic [63:0] ExPC, ExDa, ExDb, ExImm12Ext, ExImm9Ext, WbMemDataToReg, MemALUOut;
	input  logic [2:0]  ExALUOp;
   	input  logic [1:0]  ExALUSrc, ForwardDa, ForwardDb;
   	input  logic        ExFlagWrite, clk, reset;

   // Output Logic 
	output logic [63:0] ExALUOut, ExFwdDb;
	output logic 		ExOverflow, ExNegative, ExZero, ExCarryout, BLTBrTaken;

	// Intermediate Logic
	logic 		 Overflow, Negative, Zero, Carryout;
	logic		 NotExFlagWrite, XorExNegOver, XorNegOver, AndFlagWriteXor, AndNotFlagWriteXor;
	
	// ALUSrc
	logic [63:0] ALUSrcOut;
	mux4to1_64bit ALUSrcMux (.select(ExALUSrc), .in({64'bx, ExImm9Ext, ExImm12Ext, ExDb}), .out(ALUSrcOut));
	
	// The ALU
	alu TheAlu (.A(ExDa), .B(ALUSrcOut), .cntrl(ExALUOp), .result(ExALUOut), .negative(Negative), .zero(Zero), .overflow(Overflow), .carry_out(Carryout));
	
	// Flag Register
	FlagReg TheFlagRegister (.clk, .reset, .enable(ExFlagWrite), .in({Negative, Carryout, Overflow, Zero}), .out({ExNegative, ExCarryout, ExOverflow, ExZero}));

	
	// BLTBRTaken Logic: (~ExFlagWrite & (ExNegative ^ ExOverflow)) | (ExFlagWrite & (Negative ^ Overflow))
	not #0.05 n0 (NotExFlagWrite, ExFlagWrite);
	xor #0.05 x0 (XorExNegOver, ExNegative, ExOverflow);
	xor #0.05 x1 (XorNegOver, Negative, Overflow);
	and #0.05 a0 (AndFlagWriteXor, ExFlagWrite, XorNegOver);
	and #0.05 a1 (AndNotFlagWriteXor, NotExFlagWrite, XorExNegOver);
	or  #0.05 o0 (BLTBrTaken, AndFlagWriteXor, AndNotFlagWriteXor);

endmodule 