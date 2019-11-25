`timescale 1ns/10ps

module mux2to1_Nbit #(parameter N = 1) (en, a, b, out);
	input logic [N-1:0] a, b;
	input logic en;
	output logic [N-1:0] out;
	logic [N-1:0] not_en_a, en_b;
	logic not_en;
	
	not #0.05 n0 (not_en, en);
	
	genvar i;
	generate
		for (i = 0; i < N; i++) begin: andGates
			and #0.05 aa (not_en_a[i], not_en, a[i]);
			and #0.05 ab (en_b[i], en, b[i]);
		end
	endgenerate

	generate
		for (i = 0; i < N; i++) begin: orGates
			or #0.05 o (out[i], not_en_a[i], en_b[i]);
		end
	endgenerate
endmodule

module mux2to1 (select, in, out);
	input  logic 		 select;
	input  logic [1:0] in;
	output logic 	    out;
	
	logic [1:0] outputs;
	logic nselect;
	not #0.05 not0 (nselect, select);
	
	and #0.05 notSelect (outputs[0], nselect, in[0]);
	and #0.05 isSelect  (outputs[1],  select, in[1]);
	or  #0.05 selectOut (out, outputs[0], outputs[1]);
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

module mux16to1 (select, in, out);
	input  logic [3:0]  select;
	input  logic [15:0] in;
	output logic 		  out;
	
	logic [1:0] muxSel;
	
	mux8to1 mux0 (.select(select[2:0]), .in(in[7:0]) , .out(muxSel[0]));
	mux8to1 mux1 (.select(select[2:0]), .in(in[15:8]), .out(muxSel[1]));
	mux2to1 mux2 (.select(select[3])  , .in(muxSel)  , .out(out));
	
endmodule

module mux32to1 (select, in, out);
	input  logic [4:0]  select;
	input  logic [31:0] in;
	output logic 		  out;
	
	logic [1:0] muxSel;
	
	mux16to1 mux0 (.select(select[3:0]), .in(in[15:0]) , .out(muxSel[0]));
	mux16to1 mux1 (.select(select[3:0]), .in(in[31:16]), .out(muxSel[1]));
	mux2to1 mux2  (.select(select[4])  , .in(muxSel)   , .out(out));
	
endmodule

module mux2to1_64bit (select, in, out);
	input  logic 		   	 select;
	input  logic [1:0][63:0] in;
	output logic [63:0] 		  out;
	
	// In data bit matrix must be transposed into
	// a new bus so that it can be managed
	// by 64, 2to1 muxes.
	logic [63:0][1:0] dataBus;
	int i, j;
	always_comb begin
		for (i=0; i < 2; i++) begin
			for (j=0; j < 64; j++) begin
				dataBus[j][i] = in[i][j];
			end
		end
	end
	
	genvar k;
	generate
		for (k=0; k < 64; k++) begin : gen_mux_64bit
			mux2to1 muxByBit (.select(select), .in(dataBus[k][1:0]), .out(out[k]));
		end
	endgenerate
endmodule

module mux4to1_64bit (select, in, out);
	input  logic [1:0]		  select;
	input  logic [3:0][63:0] in;
	output logic [63:0] 		  out;
	
	// In data bit matrix must be transposed into
	// a new bus so that it can be managed
	// by 64, 4to1 muxes.
	logic [63:0][3:0] dataBus;
	int i, j;
	always_comb begin
		for (i=0; i < 4; i++) begin
			for (j=0; j < 64; j++) begin
				dataBus[j][i] = in[i][j];
			end
		end
	end
	
	genvar k;
	generate
		for (k=0; k < 64; k++) begin : gen_mux_64bit
			mux4to1 muxByBit (.select(select[1:0]), .in(dataBus[k][3:0]), .out(out[k]));
		end
	endgenerate
endmodule

module mux32to1_64bit (select, in, out);
	input  logic [4:0]		  select;
	input  logic [31:0][63:0] in;
	output logic [63:0] 		  out;
	
	// In data bit matrix must be transposed into
	// a new bus so that it can be managed
	// by 64, 32to1 muxes.
	logic [63:0][31:0] dataBus;
	int i, j;
	always_comb begin
		for (i=0; i < 32; i++) begin
			for (j=0; j < 64; j++) begin
				dataBus[j][i] = in[i][j];
			end
		end
	end
	
	genvar k;
	generate
		for (k=0; k < 64; k++) begin : gen_mux_64bit
			mux32to1 muxByBit (.select(select[4:0]), .in(dataBus[k][31:0]), .out(out[k]));
		end
	endgenerate
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
	
		in=8'b10101010;
		for (i = 0; i < 2**3; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule 

module mux16to1_tb ();
	logic [3:0]	select;
	logic [15:0] in;
	logic  		out;
	
	mux16to1 dut (select, in, out);
	
	integer i;
	initial begin
	
		in=16'b1010101010101010;
		for (i = 0; i < 2**4; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule 

module mux32to1_tb ();
	logic [4:0]	select;
	logic [31:0] in;
	logic  		out;
	
	mux32to1 dut (select, in, out);
	
	integer i;
	initial begin
	
		in=32'b10101010101010101010101010101010;
		for (i = 0; i < 2**5; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule 

module mux4to1_64_tb ();
	logic [1:0]			 select;
	logic [3:0][63:0] in;
	logic [63:0] 		 out;
	
	mux4to1_64 dut (select, in, out);
	
	integer i;
	initial begin
	
		for (i = 0; i < 2**5; i++) begin
			in[i] = i**4;
		end
		for (i = 0; i < 2**2; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule 

module mux32to1_64_tb ();
	logic [4:0]			 select;
	logic [31:0][63:0] in;
	logic [63:0] 		 out;
	
	mux32to1_64 dut (select, in, out);
	
	integer i;
	initial begin
	
		for (i = 0; i < 2**5; i++) begin
			in[i] = i**4;
		end
		for (i = 0; i < 2**5; i++) begin
			select = i; #1000;
		end
		$stop;
		
	end
endmodule 
