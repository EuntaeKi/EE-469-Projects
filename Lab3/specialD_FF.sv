/* D_FF with enable activated. If enable is false, it will set output to be the
 * old value. Otherwise, it will refresh its value and output the input.
 * Input: d, en, clk
 * Output: q
 */
`timescale 1ns/10ps
module specialD_FF (q, d, en, clk);
	input logic d, en, clk;
	output logic q;
	logic temp;
	
	MUX2_1 m0 (.a(q), .b(d), .en, .out(temp));
	D_FF dff0 (.q(q), .d(temp), .reset(1'b0), .clk);
	
endmodule

module specialD_FF_testbench ();
	logic q, d, en, clk;
	specialD_FF dut (.q, .d, .en, .clk);
	
	parameter CLOCK_DELAY = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_DELAY/2) clk <= ~clk;
	end
	
	initial begin
		d <= 0;	en <= 0;	@(posedge clk);
								@(posedge clk);
		d <= 1;				@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
		d <= 0;				@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
					en <= 1;	@(posedge clk);
		d <= 1;				@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
		d <= 0;	en <= 0; @(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
		$stop;
	end
endmodule
	
	