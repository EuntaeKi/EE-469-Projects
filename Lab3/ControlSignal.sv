module ControlSignal (Instruction, Reg2Loc, Reg2Write, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ALUOp, UpdateFlag, fzero, foverflow, fnegative, fcout);
    
    // Input Logic
    input logic fzero, foverflow, fnegative, fcout;
    input logic [31:0] Instruction;

    // Output Logic
    output logic Reg2Loc, Reg2Write, RegWrite, MemWrite, UncondBr, UpdateFlag;
	 output logic [1:0] BrTaken, ALUSrc, MemToReg;
	 output logic [2:0] ALUOp;
    
	 // Control logic
    always_comb begin
		case (Instruction[31:21])
			11'b000101XXXXX: begin // B
				ALUOp 	  = 3'bX;
				UpdateFlag = 1'b0;
				UncondBr   = 1'b1;
				BrTaken    = 2'b01;
				MemWrite   = 1'b0;
				RegWrite   = 1'b0;
				MemToReg   = 2'bX;
				ALUSrc     = 2'bX;
				Reg2Loc    = 1'bX;
				Reg2Write  = 1'bX;
			end
			
			11'b01010100XXX: begin // B.LT
				ALUOp 	  = 3'bX;
				UpdateFlag = 1'b0;
				UncondBr   = 1'b0;
				BrTaken    = {1'b0, (fnegative ^ foverflow)};
				MemWrite   = 1'b0;
				RegWrite   = 1'b0;
				MemToReg   = 2'bX;
				ALUSrc     = 2'bX;
				Reg2Loc    = 1'bX;
				Reg2Write  = 1'bX;
			end
			
			11'b100101XXXXX: begin // BL
				ALUOp 	  = 3'bX;
				UpdateFlag = 1'b0;
				UncondBr   = 1'b1;
				BrTaken    = 2'b01;
				MemWrite   = 1'b0;
				RegWrite   = 1'b1;
				MemToReg   = 2'b10;
				ALUSrc     = 2'bX;
				Reg2Loc    = 1'bX;
				Reg2Write  = 1'b1;
			end

			11'b100101XXXXX: begin // BR
				ALUOp 	  = 3'bX;
				UpdateFlag = 1'b0;
				UncondBr   = 1'bX;
				BrTaken    = 2'b10;
				MemWrite   = 1'b0;
				RegWrite   = 1'b0;
				MemToReg   = 2'bX;
				ALUSrc     = 2'bX;
				Reg2Loc    = 1'b0;
				Reg2Write  = 1'bX;
			end
			
			11'b10110100XXX: begin // CBZ
				ALUOp 	  = 3'b000;
				UpdateFlag = 1'b0;
				UncondBr   = 1'b0;
				BrTaken    = {1'b0, fzero};
				MemWrite   = 1'b0;
				RegWrite   = 1'b0;
				MemToReg   = 2'bX;
				ALUSrc     = 2'bX;
				Reg2Loc    = 1'b0;
				Reg2Write  = 1'bX;
			end
			
			11'b10010000100: begin // ADDI
				ALUOp 	  = 3'b010;
				UpdateFlag = 1'b0;
				UncondBr   = 1'bX;
				BrTaken    = 2'b00;
				MemWrite   = 1'b0;
				RegWrite   = 1'b1;
				MemToReg   = 2'b00;
				ALUSrc     = 2'b01;
				Reg2Loc    = 1'bX;
				Reg2Write  = 1'b0;
			end
			
			11'b10101011000: begin // ADDS
				ALUOp 	  = 3'b010;
				UpdateFlag = 1'b1;
				UncondBr   = 1'bX;
				BrTaken    = 2'b00;
				MemWrite   = 1'b0;
				RegWrite   = 1'b1;
				MemToReg   = 2'b00;
				ALUSrc     = 2'b00;
				Reg2Loc    = 1'b1;
				Reg2Write  = 1'b0;
			end
			
			11'b11101011000: begin // SUBS
				ALUOp 	  = 3'b011;
				UpdateFlag = 1'b1;
				UncondBr   = 1'bX;
				BrTaken    = 2'b00;
				MemWrite   = 1'b0;
				RegWrite   = 1'b1;
				MemToReg   = 2'b00;
				ALUSrc     = 2'b00;
				Reg2Loc    = 1'b1;
				Reg2Write  = 1'b0;
			end
			
			11'b11111000010: begin // LDUR
				ALUOp 	  = 3'b010;
				UpdateFlag = 1'b0;
				UncondBr   = 1'bX;
				BrTaken    = 2'b00;
				MemWrite   = 1'b0;
				RegWrite   = 1'b1;
				MemToReg   = 2'b01;
				ALUSrc     = 2'b10;
				Reg2Loc    = 1'bX;
				Reg2Write  = 1'b0;
			end
			
			11'b11111000010: begin // STUR
				ALUOp 	  = 3'b010;
				UpdateFlag = 1'b0;
				UncondBr   = 1'bX;
				BrTaken    = 2'b00;
				MemWrite   = 1'b1;
				RegWrite   = 1'b0;
				MemToReg   = 2'bX;
				ALUSrc     = 2'b10;
				Reg2Loc    = 1'bX;
				Reg2Write  = 1'b0;
			end
		endcase
	end

	/*
	always_comb begin
		UpdateFlag = ~Instruction[28];
		UncondBr   = ~Instruction[29];
		BrTaken    = (Instruction[26] & (Instruction[31:28] != 4'b1011)) | (fzero & (Instruction[31:28] == 4'b1011));
		MemWrite   = Instruction[30] & Instruction[29] & ~Instruction[22];
		RegWrite   = 1'b0;
		MemToReg   = 2'b0;
		ALUSrc     = 2'b0;
		Reg2Loc    = Instruction[25] & Instruction[24];
		Reg2Write  = (Instruction[31] & ~Instruction[29] & Instruction[26]);
	end
	*/
endmodule
