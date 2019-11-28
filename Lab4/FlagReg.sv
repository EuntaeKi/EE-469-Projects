`timescale 1ns/10ps

module FlagReg (clk, reset, enable, in, out);

	// Input Logic
	input  logic [3:0] in; // {Negative, Cout, Overflow, Zero}
	input  logic 		 clk, reset, enable;
	
	// Output Logic
	output logic [3:0] out;
	
	// Intermediate
	logic [3:0] storeFlag;
	
	genvar i;
	generate
		for(i = 0; i < 4; i++) begin: gen_mux_dff
			mux2to1 TheMux (.select(enable), .in({in[i], out[i]}), .out(storeFlag[i]));
			D_FF theDFF (.q(out[i]), .d(storeFlag[i]), .clk(clk), .reset(reset));
		end
	endgenerate
endmodule 