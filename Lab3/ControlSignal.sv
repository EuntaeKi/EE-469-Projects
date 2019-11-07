module ControlSignal (fzero, Instruction, Reg2Loc, Reg2Write, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ALUOp, UpdateFlag);
    
    // Input Logic
    input logic fzero;
    input logic [31:0] Instruction;

    // Output Logic
    output logic Reg2Loc, Reg2Write, RegWrite, MemWrite, BrTaken, UncondBr, UpdateFlag;
	 output logic [1:0] ALUSrc, MemToReg;
	 output logic [2:0] ALUOp;
    // ALUOp logic
    always_comb begin
		if (Instruction[31] & Instruction[30] & Instruction[25] & Instruction[24])          // Subtraction
			ALUOp = 3'b011;
		else if (Instruction[31] & Instruction[30] & ~Instruction[25] & ~Instruction[24])   // Addition
			ALUOp = 3'b010;
		else if (Instruction[31] & ~Instruction[30] & Instruction[25] & Instruction[24])    // Addition
			ALUOp = 3'b010;
		else if (Instruction[31:28] == 4'b1011)                                             // Result = B
			ALUOp = 3'b0;
		else
			ALUOp = 3'bXXX;
	end

	always_comb begin
		UpdateFlag = ~Instruction[28];
		UncondBr   = ~Instruction[29];
		BrTaken    = Instruction[26] | (fzero & (Instruction[31:28] == 4'b1011));
		MemWrite   = Instruction[30] & Instruction[29] & ~Instruction[22];
		RegWrite   = 1'b0;
		MemToReg   = 2'b0;
		ALUSrc     = 2'b0;
		Reg2Loc    = Instruction[25] & Instruction[24];
		Reg2Write  = (Instruction[31] & ~Instruction[29] & Instruction[26]);
	end

endmodule
