module CPU (CLOCK_50, reset);
	// Input Logic
	input logic CLOCK_50, reset;
	
	// Divided Clock
	logic [31:0] divided_clocks;
	
	// Control Signal logics
	logic [31:0] Instruction;
	logic [2:0] ALUOp;
	logic [1:0] ALUSrc, MemToReg;
	logic Reg2Loc, Reg2Write, RegWrite, MemWrite, BrTaken, UncondBr, UpdateFlag, fzero, foverflow, fnegative, fcout;

	clockDivider clock (.clk(CLOCK_50), .divided_clocks);
	ControlSignal signal (.fzero, .Instruction, .Reg2Loc, .Reg2Write, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .BrTaken, .UncondBr, .ALUOp, .UpdateFlag);
	InstructionFetch instFetch (.clk(divided_clocks[5]), .reset, .UncondBr, .BrTaken, .Instruction);
	Datapath data (.clk(CLOCK_50), .reset, .Reg2Loc, .Reg2Write, .RegWrite, .ALUSrc, .ALUOp, .MemWrite, .MemToReg, .Instruction, .UpdateFlag, .XferSize(4'b1000), .foverflow, .fnegative, .fzero, .fcout);

endmodule 