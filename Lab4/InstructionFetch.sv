`timescale 1ns/10ps

module InstructionFetch ( 
	instruction, 
	currentPc,
	branchAddress, 
	brTaken,
	clk,
	reset	);
								  
	// Input Logic
	input  logic [63:0] branchAddress;
	input  logic 		  clk, reset, brTaken;
	
	// Output Logic
	output logic [63:0] currentPc;
	output logic [31:0] Instruction;
	
	// Intermediate Logic
	logic [63:0] addedPc, nextPc;
	
	// Feed the address and will Fetches the Instruction into the top-level module
	instructmem InstructionMemory (.address(currentPC), .instruction(Instruction), .clk);
	
	// PC + 4
	fullAdder_64 thePCAdder (.result(addedPc), .A(currentPc), .B(64'd4), .cin(1'b0), .cout());
	
	
	// Pick PC or BranchedPC
	mux2to1_64bit (.select(brTaken), .in({branchAddress, addedPc}), .out(nextPc));
	
	ProgramCounter PC (.clk, .reset, .in(nextPC), .out(currentPC));
endmodule 