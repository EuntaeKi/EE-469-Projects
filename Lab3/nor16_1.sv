`timescale 1ns/10ps
module nor16_1 (in, out);
	input logic [15:0] in;
	output logic out;
	logic [3:0] temp;
	
	or #0.05 o0 (temp[0], in[0], in[1], in[2], in[3]);
	or #0.05 o1 (temp[1], in[4], in[5], in[6], in[7]);
	or #0.05 o2 (temp[2], in[8], in[9], in[10], in[11]);
	or #0.05 o3 (temp[3], in[12], in[13], in[14], in[15]);
	nor #0.05 n0 (out, temp[0], temp[1], temp[2], temp[3]);
endmodule

`timescale 1ns/10ps
module nor16_1_testbench ();
	logic [15:0] in;
	logic out;
	
	nor16_1 dut (.*);
	
	initial begin
		in = 16'b0; #10;
		in = 16'b1; #10;
		in = 16'h1111;	#10;
		in = 16'hFFFF; #10;
		$stop;
	end
endmodule
	
	