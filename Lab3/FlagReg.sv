// Stored as {Negative, Overflow, Cout}
module FlagReg (clk, reset, enable, in, out);
	// Input Logic
	input  logic clk, reset, enable;
	input  logic [2:0] in;
	
	// Output Logic
	output logic [2:0] out;
	
	// Intermediate
	logic [2:0] storeFlag;

	genvar i;
	generate
		for(i = 0; i < 3; i++) begin: gen_mux_dff
			mux2to1 TheMux (.select(en), .in({in[i], out[i]}), .out(storeFlag[i]));
			D_FF theDFF (.q(out[i]), .d(storeFlag[i]), .clk(clk), .reset(reset));
		end
		
	endgenerate
endmodule 