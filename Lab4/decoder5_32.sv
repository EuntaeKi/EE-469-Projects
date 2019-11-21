module decoder5_32 (in, out, en);
	input logic [4:0] in;
	input logic en;
	output logic [31:0] out;
	
	logic [3:0] tempOut;
	
	decoder2_4 d1 (.in(in[4:3]), .out(tempOut), .en);
	decoder3_8 d2 (.in(in[2:0]), .out(out[7:0]), .en(tempOut[0]));
	decoder3_8 d3 (.in(in[2:0]), .out(out[15:8]), .en(tempOut[1]));
	decoder3_8 d4 (.in(in[2:0]), .out(out[23:16]), .en(tempOut[2]));
	decoder3_8 d5 (.in(in[2:0]), .out(out[31:24]), .en(tempOut[3]));
endmodule

module decoder5_32_testbench ();
	logic [4:0] in, not_in;
	logic en;
	logic [31:0] out;
	
	decoder5_32 dut (.in, .out, .en);
	
	integer i;
	
	initial begin
		for(i = 0; i < 64; i++) begin
			{en, in} = i; #10;
		end
	end
endmodule