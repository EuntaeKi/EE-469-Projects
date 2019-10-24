`timescale 1ns/10ps

module mux2to1 (select, in, out);
	input  logic 		 select;
	input  logic [1:0] in;
	output logic 	    out;
	
	logic [1:0] outputs;
	logic nselect;
	not not0 (nselect, select);
	
	and notSelect (outputs[0], nselect, in[0]);
	and isSelect  (outputs[1],  select, in[1]);
	or  selectOut (out, outputs[0], outputs[1]);
endmodule 

module mux4to1 (select, in, out);
	input  logic [1:0] select;
	input  logic [3:0] in;
	output logic 		 out;
	
	logic [1:0] muxSel;
	
	mux2to1 mux0 (.select(select[0]), .in(in[1:0]), .out(muxSel[0]));
	mux2to1 mux1 (.select(select[0]), .in(in[3:2]), .out(muxSel[1]));
	mux2to1 mux2 (.select(select[1]), .in(muxSel) , .out(out));
	
endmodule

module mux8to1 (select, in, out);
	input  logic [2:0] select;
	input  logic [7:0] in;
	output logic 		 out;
	
	logic [1:0] muxSel;
	
	mux4to1 mux0 (.select(select[1:0]), .in(in[3:0]), .out(muxSel[0]));
	mux4to1 mux1 (.select(select[1:0]), .in(in[7:4]), .out(muxSel[1]));
	mux2to1 mux2 (.select(select[2])  , .in(muxSel) , .out(out));
	
endmodule

/*** TEST BENCHES ***/
module mux2to1_tb ();
	logic 		select;
	logic [1:0] in;
	logic  		out;
	
	mux2to1 dut (select, in, out);
	
	integer i;
	initial begin
	
		in=2'b10;
		for (i = 0; i < 2**1; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule

module mux4to1_tb ();
	logic [1:0]	select;
	logic [3:0] in;
	logic  		out;
	
	mux4to1 dut (select, in, out);
	
	integer i;
	initial begin
	
		in=4'b1010;
		for (i = 0; i < 2**2; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule 

module mux8to1_tb ();
	logic [2:0]	select;
	logic [7:0] in;
	logic  		out;
	
	mux8to1 dut (select, in, out);
	
	integer i;
	initial begin
	
		in=8'b00000110;
		for (i = 0; i < 2**3; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule 