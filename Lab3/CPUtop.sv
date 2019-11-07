module CPUtop (Rd, Rm, Rn, CLOCK_50, reset, AddI12, CondAddr19, BrAddr26);
	input logic [11:0] AddI12;
	input logic [18:0] CondAddr19;
	input logic [25:0] BrAddr26;
	input logic CLOCK_50, reset;
	input logic [63:0] Rd, Rm, Rn;
	logic [31:0] divided_clocks;
	logic [31:0] opCode;
	logic [2:0] ALUOp;
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, Zero;
	
	clockDivider clock (.clk(CLOCK_50), .divided_clocks);
	CPUcontrol control (.*, .clk(divided_clocks[10]), .UncondBr, .BrTaken);
	CPUdatapath data ();
	
	always_comb begin
		if (opCode[31] & opCode[30] & opCode[25] & opCode[24])
			ALUOp = 3'b011;
		else if (opCode[31] & opCode[30] & ~opCode[25] & ~opCode[24])
			ALUOp = 3'b010;
		else if (opCode[31] & ~opCode[30] & opCode[25] & opCode[24])
			ALUOp = 3'b010;
		else if (opCode[31:28] == 4'b1011)
			ALUOp = 3'b0;
		else
			ALUOp = 3'bXXX;
	end
	
	assign UncondBr = ~opCode[31];
	assign BrTaken = (Zero & (opCode[31:28] == 4'b1011)) | ~opCode[31];
	assign MemWrite = opCode[30] & opCode[29] & ~opCode[22];
	assign RegWrite = (opCode[25] & opCode[24]) | opCode[22];
	assign RegToMem = opCode[22];
	assign ALUSrc = opCode[30] & opCode[29];
	assign Reg2Loc = opCode[25] & opCode[24];
endmodule