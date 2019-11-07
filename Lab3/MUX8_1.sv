/* 8:1 Multiplexer. Depending on the en signal, it will select which
 * in will output
 * Input: [2:0] en, [7:0] in
 * Output: out
 */
`timescale 1ns/10ps
module MUX8_1 (in, en, out);
	input logic [7:0] in;
	input logic [2:0] en;
	output logic out;
	logic [1:0] tempOut;
	
	// Take 2 4:1 MUX and feed it through 2:1 MUX - which will behave like a 8:1 MUX
	MUX4_1 m0 (.in(in[7:4]), .en(en[1:0]), .out(tempOut[1]));
	MUX4_1 m1 (.in(in[3:0]), .en(en[1:0]), .out(tempOut[0]));
	MUX2_1 m2 (.a(tempOut[0]), .b(tempOut[1]), .en(en[2]), .out);
endmodule

module MUX8_1_testbench ();
	logic [7:0] in;
	logic [2:0] en;
	logic out;
	MUX8_1 dut (.in, .en, .out);
	
	// Not using for loop to test every possible condition because that's way too many
	initial begin
		in = 8'b00000000; en = 3'b000;	#10;	// Outputs false because 0th bit is 0
		in = 8'b00000001; en = 3'b000;	#10;	// Outputs true because 0th bit is 1
		in = 8'b00000001; en = 3'b001;	#10;	// Outputs false because 1st bit is 0
		in = 8'b00000010; en = 3'b001;	#10;	// Outputs true because 1st bit is 0
		in = 8'b00000010; en = 3'b010;	#10;	// Outputs false because 2nd bit is 0
		in = 8'b00000100; en = 3'b010;	#10;	// Outputs true because 2nd bit is 0
		in = 8'b00000100; en = 3'b011;	#10;	// Outputs false because 3rd bit is 0
		in = 8'b00001000; en = 3'b011;	#10;	// Outputs true because 3rd bit is 0
		in = 8'b00001000; en = 3'b100;	#10;	// Outputs false because 4th bit is 0
		in = 8'b00010000; en = 3'b100;	#10;	// Outputs true because 4th bit is 0
		in = 8'b00010000; en = 3'b101;	#10;	// Outputs false because 5th bit is 0
		in = 8'b00100000; en = 3'b101;	#10;	// Outputs true because 5th bit is 0
		in = 8'b00100000; en = 3'b110;	#10;	// Outputs false because 6th bit is 0
		in = 8'b01000000; en = 3'b110;	#10;	// Outputs true because 6th bit is 0
		in = 8'b01000000; en = 3'b111;	#10;	// Outputs false because 7th bit is 0
		in = 8'b10000000; en = 3'b111;	#10;	// Outputs true because 7th bit is 0
	end
endmodule