`timescale 1ns/10ps

module InstructionFetch ( 
	Instruction, 
	currentPC,
	branchAddress,
	brTaken,
	clk,
	reset	);
								  
	// Input Logic
	input  logic [63:0] branchAddress;
	input  logic brTaken, clk, reset;
	
	// Output Logic
	output logic [63:0] currentPC;
	output logic [31:0] Instruction;
	
	logic [63:0] addedPC, nextPC;
	
	// Feed the address and will Fetches the Instruction into the top-level module
	instructmem InstructionMemory (.address(currentPC), .instruction(Instruction), .clk);
	
	// PC + 4
	fullAdder_64 thePCAdder (.result(addedPC), .A(currentPC), .B(64'd4), .cin(1'b0), .cout());
	
	// Pick PC or BranchedPC
	mux2to1_64bit BrMUX (.select(brTaken), .in({branchAddress, addedPC}), .out(nextPC));
	
	ProgramCounter PC (.clk, .reset, .in(nextPC), .out(currentPC));
endmodule 