module register64 (reset, clk, write, in, out);
	input  logic 		  reset, clk, write;
	input  logic [63:0] in;
	output logic [63:0] out;
	
	logic [63:0] storeData;
	
	genvar i;
	generate
		for (i=0; i < 64; i++) begin : gen_reg_dff
			mux2to1 dSel (.select(write), .in({in[i], out[i]}), .out(storeData[i]));
			D_FF 	  ff   (.q(out[i]), .d(storeData[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule 

/*** TEST BENCHES ***/
module register64_tb ();
	logic 		 reset, clk, write;
	logic [63:0] in;
	logic [63:0] out;
	
	register64 dut (reset, clk, write, in, out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2)clk <= ~clk;
	end
	
	initial begin
		reset<=1; in<=3200; write<=0; @(posedge clk);
		reset<=0; 			  write<=1;	@(posedge clk);
												@(posedge clk);
					 in<=4900; write<=0; @(posedge clk);
					 			  write<=1; @(posedge clk);
		reset<=1;			  write<=0; @(posedge clk);

		$stop;
	end
endmodule