`timescale 1ns/10ps

module fullAdder (result, A, B, cin, cout);
	input  logic A, B, cin;
	output logic result, cout;
	logic xorAB, andAB, andCX;
	
	xor #0.05 xor0 (xorAB, A, B);
	xor #0.05 xor1 (result, xorAB, cin);
	and #0.05 and0 (andAB, A, B);
	and #0.05 and1 (andCX, cin, xorAB);
	or  #0.05 or0  (cout, andAB, andCX);
endmodule 

module fullAdder_64(result, A, B, cin, cout);
	input  logic [63:0] A, B;
	input  logic cin, cout;
	
	output logic [63:0] result;
	logic [63:0] carries;
	
	fullAdder TheFirstAdder (.result(result[0]), .A(A[0]), .B(B[0]), .cin(cin), .cout(carries[0]));
	genvar i;
	generate 
		for (i = 1; i < 64; i++) begin: gen_other_adders
			fullAdder theOtherAdders (.result(result[i]), .A(A[i]), .B(B[i]), .cin(carries[i-1]), .cout(carries[i]));
		end
	endgenerate
	
	assign cout = carries[63];
	
endmodule

module fullAdder_tb();
	logic A, B, cin, cout, result;		
	
	fullAdder dut (.result(result), .A(A), .B(B), .cin(cin), .cout(cout));
	
	integer i;
	initial begin
		for (i = 0; i < 2**3; i++) begin
			{A, B, cin} = i; #10;
		end
		$stop;
	end
endmodule