`timescale 1ns/10ps

module alu_1bit (ctrl, A, B, cout, cin, out);
	input  logic [2:0]  ctrl;
	input  logic A, B, cin;
	
   output logic out, cout;
	
	logic [7:0] results;
	logic       adderB;
	
	mux2to1 invertB (.select(ctrl[0]), .in({~B, B}), .out(adderB));
	fullAdder adder (.result(results[2]), .A(A), .B(adderB), .cin(cin), .cout(cout));
	
	// Result 2 and 3 the same result, both from adder.
	assign results[3] = results[2];
	
	assign results[0] = B;
	assign results[4] = A & B;
	assign results[5] = A | B;
	assign results[6] = A ^ B;

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