/* 32:1 Multiplexer. Depending on the en signal, it will select which
 * in will output
 * Input: [4:0] en, [31:0] in
 * Output: out
 */
module MUX32_1 (in, en, out);
	input logic [31:0] in;
	input logic [4:0] en;
	output logic out;
	logic [3:0] tempOut;
	
	// 4 8:1 MUX and output of those fed into 4:1 MUX behaves like 32:1 MUX
	MUX8_1 m0 (.in(in[31:24]), .en(en[2:0]), .out(tempOut[3]));
	MUX8_1 m1 (.in(in[23:16]), .en(en[2:0]), .out(tempOut[2]));
	MUX8_1 m2 (.in(in[15:8]), .en(en[2:0]), .out(tempOut[1]));
	MUX8_1 m3 (.in(in[7:0]), .en(en[2:0]), .out(tempOut[0]));
	MUX4_1 m4 (.in(tempOut[3:0]), .en(en[4:3]), .out);
endmodule

module MUX32_1_testbench ();
	logic [31:0] in;
	logic [4:0] en;
	logic out;
	MUX32_1 dut (.in, .en, .out);
	
	integer i = 1;
	integer j = 0;
	integer k = 0;
	
	// Not using for loop to test every possible condition because that's way too many
	initial begin
		for (k = 0; k < 32; k++) begin
									in = i;	en = j;	#10;
									in = i;	en = j;	#10;
							j++;	in = i;	en = j;	#10;
			i = i * 2;			in = i;	en = j;	#10;
		end
	end
endmodule