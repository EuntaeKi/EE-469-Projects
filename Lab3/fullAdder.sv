`timescale 1ns/10ps
module fullAdder (a, b, cin, sum, cout);
	input logic a, b, cin;
	output logic sum, cout;
	logic ab, bc, ca;
	
	xor #0.05 x0 (sum, a, b, cin);
	and #0.05 a0 (ab, a, b);
	and #0.05 a1 (bc, b, cin);
	and #0.05 a2 (ca, cin, a);
	or #0.05 o0 (cout, ab, bc, ca);
endmodule

module fullAdder_testbench ();
	logic a, b, cin, sum, cout;
	
	fullAdder dut (.a, .b, .cin, .sum, .cout);
	
	integer i;
	initial begin
		for(i = 0; i < 8; i++) begin
			{ a, b, cin } = i;	#10;
		end
	end
endmodule