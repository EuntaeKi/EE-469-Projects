module ZeroExtend #(parameter N = 12) (in, out);
	input  logic [N-1:0] in;
	output logic [63:0]  out;

	assign out[63:N] = {(64-N){1'b0}};	
	assign out[N-1:0] = in[N-1:0];
endmodule

module signExtend_testbench ();
	logic [4:0] in;
	logic [63:0] out;
	
	signExtend dut (.in, .out);
	
	initial begin
		in = 5'd00110; #10;
		in = 5'd10111;	#10;
	end
endmodule 