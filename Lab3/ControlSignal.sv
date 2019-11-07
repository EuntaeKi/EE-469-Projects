module ControlSignal (fzero, Instruction, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ALUOp, updateFlag);
    
    // Input Logic
    input logic fzero;
    input logic [2:0] ALUOp;
    input logic [31:0] Instruction;

    // Output Logic
    output logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, updateFlag;
	
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

    // Control Signal Logic
    assign updateFlag = ~Instruction[28];
	assign UncondBr = ~Instruction[31];
	assign BrTaken = (fzero & (Instruction[31:28] == 4'b1011)) | ~Instruction[31];
	assign MemWrite = Instruction[30] & Instruction[29] & ~Instruction[22];
	assign RegWrite = (Instruction[25] & Instruction[24]) | Instruction[22];
	assign RegToMem = Instruction[22];
	assign ALUSrc = Instruction[30] & Instruction[29];
	assign Reg2Loc = Instruction[25] & Instruction[24];

endmodule
