module fullAdder_64 (input logic [63:0] a, input logic [63:0] b, output logic [63:0] out);
	
	logic [63:0] carryHold;
	
	genvar i;
	generate
		for(i = 0; i < 64; i++) begin : eachi
			if (i == 0)
				fullAdder fa (.a(a[0]), .b(b[0]), .cin(1'b0), .sum(out[0]), .cout(carryHold[0]));
			else
				fullAdder fa (.a(a[i]), .b(b[i]), .cin(carryHold[i-1]), .sum(out[i]), .cout(carryHold[i]));
		end
	endgenerate
endmodule

`timescale 1ns/10ps
module fullAdder_64_testbench ();
	logic [63:0] a, b, out;
	
	fullAdder_64 dut (.*);
	
	initial begin
		a = 64'hFFFFFFFFFFFFFFFF;	b = 64'hFFFFFFFFFFFFFFFF;	#10;
		a = 64'h0;						b = 64'h0;						#10;
		a = 64'h1;															#10;
		a = 64'h1;						b = 64'h1;						#10;
		$stop;
	end
	
endmodule