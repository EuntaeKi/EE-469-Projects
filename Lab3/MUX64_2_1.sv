/* 2:1 Multiplexer. If the en is true, it will output in b. Otherwise,
 * it will output a.
 * Input: a, b, en
 * Output: out
 */
`timescale 1ns/10ps
module MUX64_2_1 (a, b, en, out);
	parameter N = 64;
	input logic [N-1:0] a, b;
	input logic en;
	output logic [N-1:0] out;
	logic [N-1:0] not_en_a, en_b;
	logic noten;
	
	not #0.05 n0 (not_en, en);
	
	genvar i;
	generate
		for (i = 0; i < N; i++) begin: andGates
			and #0.05 aa (not_en_a[i], not_en, a[i]);
			and #0.05 ab (en_b[i], en, b[i]);
		end
	endgenerate

	generate
		for (i = 0; i < N; i++) begin: orGates
			or #0.05 o (out[i], not_en_a[i], en_b[i]);
		end
	endgenerate
endmodule

module MUX64_2_1_testbench ();
	logic a, b, en, out;
	MUX2_1 dut (.a, .b, .en, .out);
	
	integer i;
	initial begin
		for(i = 0; i < 8; i++)
			{en, a, b} = i;
	end
endmodule