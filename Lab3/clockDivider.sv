// Divides the clock into 32 different frequencies
// 1 means 25 MHz and the frequency reduces over as the index increases 
module clockDivider (clk, divided_clocks);
	input logic clk;
	output logic [31:0] divided_clocks = 0;
	
	always_ff @(posedge clk) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule

module clockDivider_testbench ();
	logic clk, divided_clocks;
	parameter CLOCK_DELAY = 100;
	clockDivider dut (clk, divided_clocks);
	
	initial begin
		clk <= 0;
		forever #(CLOCK_DELAY/2) clk <= ~clk;
	end
	
	initial begin
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
								@(posedge clk)
		$stop;
	end
endmodule