`timescale 1ns/10ps

module InstructionFetch ( clk, 
								  reset,
								  Instruction, 
								  BrTaken, 
								  UncondBr,
								  Db, 
								  NoBranchPC );
								  
	// Input Logic
	input  logic [63:0] Db;
	input  logic [1:0]  BrTaken;
	input  logic        clk, reset, UncondBr;
	
	// Output Logic
	output logic [63:0] NoBranchPC;
	output logic [31:0] Instruction;
	
	// Intermediate Logic
	logic [63:0] condAddr, uncondAddr, brAddr, shiftedAddr, brPcAddr, currentPC, updatedPC;
	
	// Feed the address and will Fetches the Instruction into the top-level module
	instructmem InstructionMemory (.address(currentPC), .instruction(Instruction), .clk);
	
	// PC + 4; used by X30 if BL instruction
	fullAdder_64 advancePc (.result(NoBranchPC), .A(currentPC), .B(64'd4), .cin(1'b0), .cout());
	
	// Sign Extend the address inputs
	// Instruction[23:5] is CondAddr19
	// Instruction[25:0] is BrAddr26
	SignExtend #(.N(19)) ExtendCondAddr (.in(Instruction[23:5]), .out(condAddr));
	SignExtend #(.N(26)) ExtendBrAddr (.in(Instruction[25:0]), .out(uncondAddr));
	
	// MUX whether or not it's an unconditional branch
	mux2to1_Nbit #(.N(64)) MuxCond (.en(UncondBr), .a(condAddr), .b(uncondAddr), .out(brAddr));
	
	// Shift the brAddr by 2 bits to multiply it by 4
	shifter TheShifter (.value(brAddr), .direction(1'b0), .distance(6'b000010), .result(shiftedAddr));

	// Add the shiftedAddr with currentPC
	fullAdder_64 TheBranchAdder (.result(brPcAddr), .A(currentPC), .B(shiftedAddr), .cin(1'b0), .cout());

	// Determine if branch instruction was given or not
	// The result goes into PC regardless to update the PC
	mux4to1_64bit MuxBranch (.select(BrTaken), .in({64'b0, Db, brPcAddr, NoBranchPC}), .out(updatedPC));

	// Register that hold the ProgramCounter
	// Current PC gets fed into IM (Instruction Memory)
	ProgramCounter PC (.clk, .reset, .in(updatedPC), .out(currentPC));
endmodule 