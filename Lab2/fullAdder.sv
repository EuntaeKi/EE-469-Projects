module fullAdder (result, A, B, cin, cout);
	input  logic A, B, cin;
	output logic result, cout;
	
	assign {cout, result} = A + B + cin;
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