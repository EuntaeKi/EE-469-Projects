module InstructionFetch (clk, reset, UncondBr, BrTaken, Instruction);
	// Input Logic
	input logic clk, reset, UncondBr, BrTaken;
	
	// Output Logic
	output logic [31:0] Instruction;
	
	// Intermediate Logic
	logic [63:0] condAddr, brAdder, muxedAddr, shiftedAddr, branchedAddr, currentPC, updatedPC;
	
	// Sign Extend the address inputs
	// Instruction[23:5] is CondAddr19
	// Instruction[25:0] is BrAddr26
	signExtend signExtendCondAddr (.in(Instruction[23:5]), .out(condAddr));
	signExtend signExtendBrAddr (.in(Instruction[25:0]), .out(brAddr));
	
	// MUX whether or not it's an unconditional branch
	mux2to1_Nbit #(.N(64)) condMUX (.en(UncondBr), .a(condAddr), .b(brAddr), .out(muxedAddr));
	
	// Shift the muxedAddr by 2 bits to multiply it by 4
	shifter shift (.value(condAddr), .direction(1'b0), .distance(5'b00010), .result(shiftedAddr));

	// Add the shiftedAddr with currentPC
	fullAdder_64 add (.a(currentPC), .b(shiftedCond), .out(branchedAddr));

	// Determine if branch instruction was given or not
	// The result goes into PC regardless to update the PC
	mux2to1_Nbit #(.N(64)) brMUX (.en(BrTaken), .a(currentPC + 3'b100), .b(branchedAddr), .out(updatedPC));

	// Register that hold the ProgramCounter
	// Current PC gets fed into IM (Instruction Memory)
	programCounter pc (.in(updatedPC), .clk, .reset, .out(currentPC));

	// Feed the address and will Fetches the Instruction into the top-level module
	instructmem instmem (.address(currentPC), .instruction(Instruction), .clk);	
endmodule 