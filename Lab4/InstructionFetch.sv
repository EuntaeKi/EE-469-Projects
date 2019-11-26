`timescale 1ns/10ps

module InstructionFetch ( 
	Instruction, 
	currentPC,
	branchAddress,
	Db,
	brTaken,
	clk,
	reset	);
								  
	// Input Logic
	input  logic [63:0] branchAddress, Db;
	input  logic [1:0]  brTaken;
	input  logic 		  clk, reset;
	
	// Output Logic
	output logic [63:0] currentPC;
	output logic [31:0] Instruction;
	
	logic [63:0] addedPC, nextPC;
	
	// Feed the address and will Fetches the Instruction into the top-level module
	instructmem InstructionMemory (.address(currentPC), .instruction(Instruction), .clk);
	
	// PC + 4
	fullAdder_64 thePCAdder (.result(addedPC), .A(currentPC), .B(64'd4), .cin(1'b0), .cout());
	
	logic [63:0] shiftedAddr, branchedPC, noBranchPC;
	// If branched
	shifter TheShifter (.value(branchAddress), .direction(1'b0), .distance(6'b000010), .result(shiftedAddr));
	fullAdder_64 TheBranchAdder (.result(branchedPC), .A(currentPC), .B(shiftedAddr), .cin(1'b0), .cout());
	
	// Pick PC or BranchedPC
	mux4to1_64bit BrMUX (.select(brTaken), .in({64'b0, Db, branchedPC, addedPC}), .out(nextPC));
	
	ProgramCounter PC (.clk, .reset, .in(nextPC), .out(currentPC));
endmodule 