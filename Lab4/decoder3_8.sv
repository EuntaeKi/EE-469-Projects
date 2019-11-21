/*	3:8 Decoder. Building block of 5:32 decoder - regDecoder
 * Depending on the en signal, it will choose what to output
 *	Input: en, [2:0] in
 * Output: [7:0] out
 */
`timescale 1ns/10ps
module decoder3_8 (in, out, en);
	input logic [2:0] in;
	input logic en;
	output logic [7:0] out;
	logic [2:0] not_in;
	
	not #0.05 n0 (not_in[0], in[0]);
	not #0.05 n1 (not_in[1], in[1]);
	not #0.05 n2 (not_in[2], in[2]);
	
	and #0.05 a0 (out[0], not_in[0], not_in[1], not_in[2], en);
	and #0.05 a1 (out[1], in[0], not_in[1], not_in[2], en);
	and #0.05 a2 (out[2], not_in[0], in[1], not_in[2], en);
	and #0.05 a3 (out[3], in[0], in[1], not_in[2], en);
	and #0.05 a4 (out[4], not_in[0], not_in[1], in[2], en);
	and #0.05 a5 (out[5], in[0], not_in[1], in[2], en);
	and #0.05 a6 (out[6], not_in[0], in[1], in[2], en);
	and #0.05 a7 (out[7], in[0], in[1], in[2], en);	
endmodule

module decoder3_8_testbench ();
	logic [2:0] in, not_in;
	logic en;
	logic [7:0] out;
	
	decoder3_8 dut (.in, .out, .en);
	
	integer i;
	
	initial begin
		for(i = 0; i < 16; i++) begin
			{en, in} = i; #10;
		end
	end
endmodule