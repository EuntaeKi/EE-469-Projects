`timescale 1ns/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);

	input  logic [2:0]  cntrl;
	input  logic [63:0] A, B;
	
   output logic [63:0] result;
	output logic        negative, zero, overflow, carry_out;

	logic [63:0] alu_cout;
	
	// Generate the single-slice ALUs
	alu_1bit theFirstAlu (.ctrl(cntrl), .A(A[0]), .B(B[0]), .cout(alu_cout[0]), .cin(cntrl[0]), .out(result[0]));
	genvar i;
	generate
		for (i = 1; i < 64; i++) begin : gen_alus
			alu_1bit theAlus (.ctrl(cntrl), .A(A[i]), .B(B[i]), .cout(alu_cout[i]), .cin(alu_cout[i-1]), .out(result[i]));
		end
	endgenerate
	
	// Assign the ALU output stats
	assign negative = result[63];
	assign zero = ~|result[63:0];
	assign overflow = alu_cout[63] ^ alu_cout[62];
	assign carry_out = alu_cout[63];
	
endmodule 