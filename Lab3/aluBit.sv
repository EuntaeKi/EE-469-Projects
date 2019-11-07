`timescale 1ns/10ps

module aluBit (a, b, cin, aluOp, out, cout);
	input logic a, b, cin;
	input logic [2:0] aluOp;
	output logic out, cout;
	logic muxedB;
	logic [3:0] result;
	
	MUX2_1 m0 (.a(b), .b(~b), .en(aluOp[0]), .out(muxedB));
	fullAdder f0 (.a, .b(muxedB), .cin, .sum(result[0]), .cout);	// Does add and subtract
	and #0.05 a0 (result[1], a, b);
	or #0.05 o0 (result[2], a, b);
	xor #0.05 x0 (result[3], a, b);
	
	MUX8_1 m1 (.in({ 1'bX, result[3], result[2], result[1], result[0], result[0], 1'bX, b }), .en(aluOp), .out);
endmodule


module aluBit_testbench ();
	logic a, b, cin, out, cout;
	logic [2:0] aluOp;
	
	aluBit dut (.a, .b, .cin, .aluOp, .out, .cout);
	
	integer i;
	initial begin
		for (i = 0; i < 64; i++) begin
			{ aluOp, cin, b, a } = i; #10;
		end
		$stop;
	end
endmodule
		
