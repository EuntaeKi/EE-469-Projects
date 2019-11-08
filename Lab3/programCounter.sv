module ProgramCounter (clk, reset, in, out);
	
	// Input Logic
	input  logic [63:0] in;
	input  logic        clk, reset;
	
	// Output Logic
	output logic [63:0] out;
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: register
			D_FF dff1 (.q(out[i]), .d(in[i]), .reset, .clk);
		end
	endgenerate
endmodule 