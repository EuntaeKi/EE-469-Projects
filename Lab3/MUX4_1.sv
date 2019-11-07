/* 4:1 Multiplexer. Depending on the en signal, it will select which
 * in will output
 * Input: [1:0] en, [3:0] in
 * Output: out
 */
`timescale 1ns/10ps
module MUX4_1 (in, en, out);
	input logic [3:0] in;
	input logic [1:0] en;
	output logic out;
	logic [1:0] not_en;
	logic [3:0] temp;
	
	not #0.05 n0 (not_en[0], en[0]);
	not #0.05 n1 (not_en[1], en[1]);
	and #0.05 a0 (temp[3], in[3], en[0], en[1]);
	and #0.05 a1 (temp[2], in[2], not_en[0], en[1]);
	and #0.05 a2 (temp[1], in[1], en[0], not_en[1]);
	and #0.05 a3 (temp[0], in[0], not_en[0], not_en[1]);
	or #0.05 o (out, temp[3], temp[2], temp[1], temp[0]);
endmodule
	
module MUX4_1_testbench ();
	logic [3:0] in;
	logic [1:0] en;
	logic out;
	MUX4_1 dut (.in, .en, .out);
	
	integer i;
	initial begin
		for(i = 0; i < 64; i++) begin
			{en, in} = i; #10;
		end
	end
endmodule