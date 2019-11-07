/* 2:1 Multiplexer. If the en is true, it will output in b. Otherwise,
 * it will output a.
 * Input: a, b, en
 * Output: out
 */
`timescale 1ns/10ps
module MUX2_1 (a, b, en, out);
	input logic a, b, en;
	output logic out;
	logic not_en, not_en_a, en_b;
	
	not #0.05 n0 (not_en, en);
	and #0.05 a0 (not_en_a, not_en, a);
	and #0.05 a1 (en_b, en, b);
	or #0.05 o (out, not_en_a, en_b);
endmodule

module MUX2_1_testbench ();
	logic a, b, en, out;
	MUX2_1 dut (.a, .b, .en, .out);
	
	integer i;
	initial begin
		for(i = 0; i < 8; i++)
			{en, a, b} = i;
	end
endmodule