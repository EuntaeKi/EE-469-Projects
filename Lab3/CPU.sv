module CPU (CLOCK_50, reset);
	// Input Logic
	input logic CLOCK_50, reset;
	
	// Divided Clock
	logic [31:0] divided_clocks;
	
	// Control Signal logics
	logic [31:0] Instruction;
	logic [2:0] ALUOp;
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, updateFlag, fzero, foverflow, fnegative, fcout;
	
	clockDivider clock (.clk(CLOCK_50), .divided_clocks);
	ControlSignal signal (.*);
	InstructionFetch instFetch (.*, .clk(divided_clocks[5]));
	DataPath data (.*, .clk(CLOCK_50), .XferSize(4'b1000));

endmodule 