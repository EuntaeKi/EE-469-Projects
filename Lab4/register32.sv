module register32 (reset, clk, write, in, out);
	input  logic 		  reset, clk, write;
	input  logic [31:0] in;
	output logic [31:0] out;
	
	logic [31:0] storeData;
	
	genvar i;
	generate
		for (i=0; i < 32; i++) begin : gen_reg_dff
			mux2to1 dSel (.select(write), .in({in[i], out[i]}), .out(storeData[i]));
			D_FF 	  ff   (.q(out[i]), .d(storeData[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule 