`timescale 1ns/10ps
module MUX5_2_1 (a, b, en, out);
	input logic [4:0] a, b;
	input logic en;
	output logic [4:0] out;
	logic [4:0] not_en_a, en_b;
	logic noten;
	
	not #0.05 n0 (not_en, en);
	
	genvar i;
	generate
		for (i = 0; i < 5; i++) begin: andGates
			and #0.05 aa (not_en_a[i], not_en, a[i]);
			and #0.05 ab (en_b[i], en, b[i]);
		end
	endgenerate

	generate
		for (i = 0; i < 5; i++) begin: orGates
			or #0.05 o (out[i], not_en_a[i], en_b[i]);
		end
	endgenerate
endmodule 