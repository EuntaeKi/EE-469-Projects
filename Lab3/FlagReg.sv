// Stored as {Zero, Negative, Overflow, Cout}
module FlagReg (clk, reset, enable, in, out);
	// Input Logic
	input  logic clk, reset, enable;
	
	// Output Logic
	output logic [3:0] in, out;
	
	// Intermediate
	logic [3:0] storeFlag;

	genvar i;
	generate
		for(i = 0; i < 4; i++) begin: gen_mux_dff
			mux_2to1 TheMux (.select(en), .a(in[i]), .b(out[i]), .out(storeFlag[i]));
			D_FF theDFF (.q(out[i]), .d(storeFlag[i]), .clk(clk), .reset(reset));
		end
		
	endgenerate
endmodule 