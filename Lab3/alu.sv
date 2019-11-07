module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);

	input  logic [2:0]  cntrl;
	input  logic [63:0] A, B;
	
   output logic [63:0] result;
	output logic        negative, zero, overflow, carry_out;

	logic [63:0] alu_cout;
	logic [15:0] zero_nor;
	logic [3:0]  zero_and;
	
	// Generate the single-slice ALUs
	alu_1bit theFirstAlu (.ctrl(cntrl), .A(A[0]), .B(B[0]), .cout(alu_cout[0]), .cin(cntrl[0]), .out(result[0]));
	genvar i;
	
	generate
		for (i = 1; i < 64; i++) begin : gen_alus
			alu_1bit theAlus (.ctrl(cntrl), .A(A[i]), .B(B[i]), .cout(alu_cout[i]), .cin(alu_cout[i-1]), .out(result[i]));
		end
	endgenerate
	
	// Gerenate Logic for zero flag
	generate
		for (i = 0; i < 16; i++) begin : gen_nor_results
			nor #0.05 norResults (zero_nor[i], result[4*i], result[4*i+1], result[4*i+2], result[4*i+3]);
		end
	endgenerate
	
	generate
		for (i = 0; i < 4; i++) begin : gen_and_results
			and #0.05 andResults (zero_and[i], zero_nor[4*i], zero_nor[4*i+1], zero_nor[4*i+2], zero_nor[4*i+3]);
		end
	endgenerate
	
	// ALU Output Stats
	xor #0.05 theOverflowXor (overflow, alu_cout[63], alu_cout[62]);
	and #0.05 theZeroAnd (zero, zero_and[0], zero_and[1], zero_and[2], zero_and[3]); 
	assign negative = result[63];
	assign carry_out = alu_cout[63];
	
endmodule 