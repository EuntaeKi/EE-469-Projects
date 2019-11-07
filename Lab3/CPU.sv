module CPUtop (CLOCK_50, reset);
	input logic CLOCK_50, reset;
	logic [11:0] AddI12;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;
	logic [4:0] Rd, Rm, Rn;
	logic [31:0] divided_clocks;
	logic [31:0] opCode;
	logic [2:0] ALUOp;
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, Zero;
	
	clockDivider clock (.clk(CLOCK_50), .divided_clocks);
	CPUcontrol control (.*, .clk(divided_clocks[10]));
	CPUdatapath data (.*);
	
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
	
	assign Rn = opCode[9:5];
	assign Rm = opCode[20:16];
	assign Rd = opCode[4:0];
	assign AddI12 = opCode[21:10];
	assign CondAddr19 = opCode[23:5];
	assign BrAddr26 = opCode[25:0];
	assign UncondBr = ~opCode[31];
	assign BrTaken = (Zero & (opCode[31:28] == 4'b1011)) | ~opCode[31];
	assign MemWrite = opCode[30] & opCode[29] & ~opCode[22];
	assign RegWrite = (opCode[25] & opCode[24]) | opCode[22];
	assign RegToMem = opCode[22];
	assign ALUSrc = opCode[30] & opCode[29];
	assign Reg2Loc = opCode[25] & opCode[24];
endmodule 