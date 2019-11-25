`timescale 1ns/10ps

module InstructionFetch ( 
	Instruction, 
	currentPC,
	nextPC,
	clk,
	reset	);
								  
	// Input Logic
	input  logic [63:0] nextPc;
	input  logic 		  clk, reset;
	
	// Output Logic
	output logic [63:0] currentPC;
	output logic [31:0] Instruction;
	
	// Feed the address and will Fetches the Instruction into the top-level module
	instructmem InstructionMemory (.address(currentPC), .instruction(Instruction), .clk);
	
	ProgramCounter PC (.clk, .reset, .in(nextPC), .out(currentPC));
endmodule 