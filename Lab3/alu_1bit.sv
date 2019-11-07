`timescale 1ns/10ps

module alu_1bit (ctrl, A, B, cout, cin, out);
	input  logic [2:0]  ctrl;
	input  logic A, B, cin;
	
   output logic out, cout;
	
	logic [7:0] results;
	logic       adderB, andAB, orAB, xorAB;
	
	mux2to1 invertB (.select(ctrl[0]), .in({~B, B}), .out(adderB));
	fullAdder adder (.result(results[2]), .A(A), .B(adderB), .cin(cin), .cout(cout));
	
	xor #0.05 theXor (xorAB, A, B);
	and #0.05 theAnd (andAB, A, B);
	or  #0.05 theOr  (orAB, A, B);
	
	// Tying signals to the mux input 
	assign results[0] = B;
	assign results[3] = results[2];
	assign results[4] = andAB;
	assign results[5] = orAB;
	assign results[6] = xorAB;

	mux8to1 selectOp (.select(ctrl[2:0]), .in(results[7:0]), .out(out));
endmodule 

module alu_1bit_tb();
	logic [2:0] ctrl; 
	logic			A, B, cout, cin, out;		
	
	alu_1bit dut (.ctrl(ctrl), .A(A), .B(B), .cout(cout), .cin(cin), .out(out));
	
	integer i;
	initial begin
		ctrl = 3'b000; A = 1'b0; B = 1'b0; cin = 0; #10;
		ctrl = 3'b010;							  cin = 0; #10;
		ctrl = 3'b011;							  cin = 1; #10;
		ctrl = 3'b100;							  cin = 0; #10;
		ctrl = 3'b101;							  cin = 1; #10;
		ctrl = 3'b110;							  cin = 0; #10;
		
		ctrl = 3'b000; A = 1'b0; B = 1'b1; cin = 0; #10;
		ctrl = 3'b010;							  cin = 0; #10;
		ctrl = 3'b011;							  cin = 1; #10;
		ctrl = 3'b100;							  cin = 0; #10;
		ctrl = 3'b101;							  cin = 1; #10;
		ctrl = 3'b110;							  cin = 0; #10;
		
		ctrl = 3'b000; A = 1'b1; B = 1'b0; cin = 0; #10;
		ctrl = 3'b010;							  cin = 0; #10;
		ctrl = 3'b011;							  cin = 1; #10;
		ctrl = 3'b100;							  cin = 0; #10;
		ctrl = 3'b101;							  cin = 1; #10;
		ctrl = 3'b110;							  cin = 0; #10;
		
		ctrl = 3'b000; A = 1'b1; B = 1'b1; cin = 0; #10;
		ctrl = 3'b010;							  cin = 0; #10;
		ctrl = 3'b011;							  cin = 1; #10;
		ctrl = 3'b100;							  cin = 0; #10;
		ctrl = 3'b101;							  cin = 1; #10;
		ctrl = 3'b110;							  cin = 0; #10;
		$stop;
	end
endmodule 