module alu (busA, busB, ctrl, out, negative, zero, overflow, cout);

	input  logic [2:0]  ctrl;
	input  logic [63:0] busA, busB;
	
   output logic [63:0] out, alu_cout;
	output logic        negative, zero, overflow, cout;

	// Generate the single-slice ALUs
	alu_1bit TheFirstAlu (.ctrl, .busA(busA[0]), .busB(busB[0]), .zero(zero[0]), .overflow(overflow[0]), .cout(alu_cout[0]), .cin(ctrl[0]), .negative(negative[i]), .out(out[i]));
	genvar i;
	generate
		for (i = 1; i < 64; i++) begin
			alu_1bit TheAlus (.ctrl, .busA(busA[i]), .busB(busB[i]), .zero(zero[i]), .overflow(overflow[i]), .cout(alu_cout[i]), .cin(alu_cout[i-1]), .negative(negative[i]), .out(out[i]));
		end
	endgenerate
	
	// Assign the ALU output stats
	assign negative = out[63];
	assign zero = ~&out[63:0];
	assign overflow = alu_cout[63] ^ alu_cout[62];
	assign cout = alu_cout[63];
	
endmodule 