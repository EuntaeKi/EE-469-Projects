/* 5:32 Decoder - decides which register needs to be written
 *	Input: [4:0] Write Register (Address), RegWrite (Enable)
 *	Output: [31:0] decodeOut
 */
module regDecoder (WriteRegister, decodeOut, RegWrite);
	input logic RegWrite;
	input logic [4:0] WriteRegister;
	output logic [31:0] decodeOut;
	
	logic [3:0] tempOut;
	
	// 2:4 decoder selects which 3:8 decoder will be overwritten - assuming RegWrite is true.
	decoder2_4 d1 (.in(WriteRegister[4:3]), .out(tempOut), .en(RegWrite));
	decoder3_8 d2 (.in(WriteRegister[2:0]), .out(decodeOut[7:0]), .en(tempOut[0]));
	decoder3_8 d3 (.in(WriteRegister[2:0]), .out(decodeOut[15:8]), .en(tempOut[1]));
	decoder3_8 d4 (.in(WriteRegister[2:0]), .out(decodeOut[23:16]), .en(tempOut[2]));
	decoder3_8 d5 (.in(WriteRegister[2:0]), .out(decodeOut[31:24]), .en(tempOut[3]));
endmodule

`timescale 1ns/10ps
module regDecoder_testbench ();
	logic [4:0] WriteRegister;
	logic RegWrite;
	logic [31:0] decodeOut;
	
	regDecoder dut (.WriteRegister, .decodeOut, .RegWrite);
	
	integer i;
	
	initial begin
		for(i = 0; i < 64; i++) begin
			{RegWrite, WriteRegister} = i; #10;
		end
	end
endmodule