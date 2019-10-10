`timescale 1ns/10ps

module decoder2to4 (enable, in, out);
	input  logic       enable;
	input  logic [1:0] in;
	output logic [3:0] out;
	
	and #0.05 out0 (out[0], enable, ~in[1], ~in[0]);
	and #0.05 out1 (out[1], enable, ~in[1],  in[0]);
	and #0.05 out2 (out[2], enable,  in[1], ~in[0]);
	and #0.05 out3 (out[3], enable,  in[1],  in[0]);
	
endmodule

module decoder3to8 (enable, in, out);
	input  logic       enable;
	input  logic [2:0] in;
	output logic [7:0] out;
	
	and #0.05 out0 (out[0], enable, ~in[2], ~in[1], ~in[0]);
	and #0.05 out1 (out[1], enable, ~in[2], ~in[1],  in[0]);
	and #0.05 out2 (out[2], enable, ~in[2],  in[1], ~in[0]);
	and #0.05 out3 (out[3], enable, ~in[2],  in[1],  in[0]);
	and #0.05 out4 (out[4], enable,  in[2], ~in[1], ~in[0]);
	and #0.05 out5 (out[5], enable,  in[2], ~in[1],  in[0]);
	and #0.05 out6 (out[6], enable,  in[2],  in[1], ~in[0]);
	and #0.05 out7 (out[7], enable,  in[2],  in[1],  in[0]);
	
endmodule

module decoder5to32 (enable, in, out);
	input  logic        enable;
	input  logic [4:0]  in;
	output logic [31:0] out;
	
	logic [3:0] decoderSel;
	decoder2to4 select (.enable(enable), .in(in[4:3]), .out(decoderSel[3:0]));
	
	genvar i;
	generate
		for (i=0; i < 4; i++) begin : gen_3to8_decoders
			decoder3to8 decoder (.enable(decoderSel[i]), .in(in[2:0]), .out(out[8*i+7:8*i]));
		end
	endgenerate
	
endmodule 

/*** TEST BENCHES ***/
module decoder2to4_tb ();
	logic 		enable;
	logic [1:0] in;
	logic [3:0] out;
	
	decoder2to4 dut (enable, in, out);
	
	integer i;
	initial begin
	
		enable=1'b0;
		for (i = 0; i < 2**2; i++) begin
			in = i; #10;
		end
		
		enable=1'b1;
		for (i = 0; i < 2**2; i++) begin
			in = i; #10;
		end
		
		$stop;
	end
endmodule 

module decoder3to8_tb ();
	logic 		enable;
	logic [2:0] in;
	logic [7:0] out;
	
	decoder3to8 dut (enable, in, out);
	
	integer i;
	initial begin
	
		enable=1'b0;
		for (i = 0; i < 2**3; i++) begin
			in = i; #10;
		end
		
		enable=1'b1;
		for (i = 0; i < 2**3; i++) begin
			in = i; #10;
		end
		
		$stop;
	end
endmodule

module decoder5to32_tb ();
	logic 		enable;
	logic [4:0] in;
	logic [31:0] out;
	
	decoder5to32 dut (enable, in, out);
	
	integer i;
	initial begin
	
		enable=1'b0;
		for (i = 0; i < 2**5; i++) begin
			in = i; #10;
		end
		
		enable=1'b1;
		for (i = 0; i < 2**5; i++) begin
			in = i; #10;
		end
		
		$stop;
	end
endmodule  