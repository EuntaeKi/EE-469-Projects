module MUX64_32_1 (in, en, out);
	input logic [63:0][31:0] in;
	input logic [4:0] en;
	output logic [63:0] out;
	logic tempOut;
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: eachMUX
			MUX32_1 mux32 (.in(in[i]), .en, .out(out[i]));
		end
	endgenerate
endmodule