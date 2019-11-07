module signExtend #(parameter N = 5) (input logic [N-1:0] in, output logic [63:0] out);

	always_comb begin
		integer i;
		for (i=0; i < N-1; i++)
			out[i] = in[i];
		for (i=N-1; i < 64; i++)
			out[i] = in[N-1];
	end
endmodule

module signExtend_testbench ();
	parameter N = 5;
	logic [N-1:0] in;
	logic [63:0] out;
	
	signExtend dut (.*);
	
	initial begin
		in = 5'd16; #10;
		#10;
		in = 5'd23;	#10;
		#10;
	end
endmodule
	