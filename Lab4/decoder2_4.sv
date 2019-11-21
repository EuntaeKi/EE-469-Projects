/*	2:4 Decoder. Building block of 5:32 decoder - regDecoder
 * Depending on the en signal, it will choose what to output
 *	Input: en, [1:0] in
 * Output: [3:0] out
 */
`timescale 1ns/10ps
module decoder2_4 (in, out, en);
	input logic [1:0] in;
	input logic en;
	output logic [3:0] out;
	logic [1:0] not_in;
	
	not #0.05 n0 (not_in[0], in[0]);
	not #0.05 n1 (not_in[1], in[1]);
	
	and #0.05 a0 (out[0], not_in[0], not_in[1], en);
	and #0.05 a1 (out[1], in[0], not_in[1], en);
	and #0.05 a2 (out[2], not_in[0], in[1], en);
	and #0.05 a3 (out[3], in[0], in[1], en);
endmodule

module decoder2_4_testbench ();
	logic [1:0] in, not_in;
	logic en;
	logic [3:0] out;
	
	decoder2_4 dut (.in, .out, .en);
	
	integer i;
	
	initial begin
		for(i = 0; i < 8; i++) begin
			{en, in} = i; #10;
		end
	end
endmodule