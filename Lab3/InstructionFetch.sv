module InstructionFetch (clk, reset, Db, UncondBr, BrTaken, Instruction, NextPC);
	// Input Logic
	input logic clk, reset, UncondBr;
	input logic [1:0] BrTaken;
	input logic [63:0] Db;
	
	// Output Logic
	output logic [31:0] Instruction;
	output logic [63:0] NextPC;
	
	// Intermediate Logic
	logic [63:0] condAddr, brAddr, muxedAddr, shiftedAddr, branchedAddr, currentPC, updatedPC;
	
	// Sign Extend the address inputs
	// Instruction[23:5] is CondAddr19
	// Instruction[25:0] is BrAddr26
	SignExtend #(.N(19)) signExtendCondAddr (.in(Instruction[23:5]), .out(condAddr));
	SignExtend #(.N(26)) signExtendBrAddr (.in(Instruction[25:0]), .out(brAddr));
	
	// MUX whether or not it's an unconditional branch
	mux2to1_Nbit #(.N(64)) condMUX (.en(UncondBr), .a(condAddr), .b(brAddr), .out(muxedAddr));
	
	// Shift the muxedAddr by 2 bits to multiply it by 4
	shifter shift (.value(condAddr), .direction(1'b0), .distance(6'b000010), .result(shiftedAddr));

	// Add the shiftedAddr with currentPC
	fullAdder_64 add (.result(branchedAddr), .A(currentPC), .B(shiftedAddr), .cin(1'b0), .cout());

	// Determine if branch instruction was given or not
	// The result goes into PC regardless to update the PC
	mux4to1_64bit brMUX (.select(BrTaken), .in({64'b0, Db, branchedAddr, currentPC + 64'd4}), .out(updatedPC));

	// Register that hold the ProgramCounter
	// Current PC gets fed into IM (Instruction Memory)
	ProgramCounter pc (.clk, .reset, .in(updatedPC), .out(currentPC));

	// Feed the address and will Fetches the Instruction into the top-level module
	instructmem instmem (.address(currentPC), .instruction(Instruction), .clk);

	assign NextPC = updatedPC;
endmodule 