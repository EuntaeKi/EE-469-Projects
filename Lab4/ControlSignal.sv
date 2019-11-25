`timescale 1ns/10ps

module ControlSignal ( Instruction, 
							  ALUOp, 
							  ALUSrc,
							  Mem2Reg,
							  BrTaken, 
							  Reg2Loc,
							  Reg2Write,
							  RegWrite,
							  MemWrite,
							  MemRead,
							  UncondBr, 
							  NegativeFlag,
							  OverflowFlag,
							  ZeroFlag );
    
    // Input Logic
	 input logic  [31:0] Instruction;
    input logic 			NegativeFlag, OverflowFlag, ZeroFlag;

    // Output Logic
	 output logic [2:0]  ALUOp;
	 output logic [1:0]  BrTaken, ALUSrc, Mem2Reg;
    output logic 		   Reg2Loc, Reg2Write, RegWrite, MemWrite, MemRead, UncondBr;
    
	 enum logic [10:0] {
		B    = 11'b000101xxxxx,
		BLT  = 11'b01010100XXX,
		BL   = 11'b100101XXXXX,
		BR   = 11'b11010110000,
		CBZ  = 11'b10110100XXX,
		ADDI = 11'b10010001000,
		ADDS = 11'b10101011000,
		SUBS = 11'b11101011000,
		LDUR = 11'b11111000010,
		STUR = 11'b11111000000
	 } OpCodes;
	 
	 // Control logic
    always_comb begin
		casex (Instruction[31:21])
		
			B: begin
				ALUOp 	 = 3'bX;
				UncondBr  = 1'b1;
				BrTaken   = 2'b01;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'bX;
			end
			
			BLT: begin
				ALUOp 	 = 3'bX;
				UncondBr  = 1'b0;
				BrTaken   = {1'b0, (NegativeFlag ^ OverflowFlag)};
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'bX;
			end
			
			BL: begin
				ALUOp 	 = 3'bX;
				UncondBr  = 1'b1;
				BrTaken   = 2'b01;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b10;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'b1;
			end

			BR: begin
				ALUOp 	 = 3'bX;
				UncondBr  = 1'bX;
				BrTaken   = 2'b10;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'b0;
				Reg2Write = 1'bX;
			end
			
			CBZ: begin
				ALUOp 	 = 3'b000;
				UncondBr  = 1'b0;
				BrTaken   = {1'b0, ZeroFlag};
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'b00;
				Reg2Loc   = 1'b0;
				Reg2Write = 1'bX;
			end
			
			ADDI: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b0;
				UncondBr  = 1'bX;
				BrTaken   = 2'b00;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b00;
				ALUSrc    = 2'b01;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'b0;
			end
			
			ADDS: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b1;
				UncondBr  = 1'bX;
				BrTaken   = 2'b00;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b00;
				ALUSrc    = 2'b00;
				Reg2Loc   = 1'b1;
				Reg2Write = 1'b0;
			end
			
			SUBS: begin
				ALUOp 	 = 3'b011;
				FlagWrite = 1'b1;
				UncondBr  = 1'bX;
				BrTaken   = 2'b00;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b00;
				ALUSrc    = 2'b00;
				Reg2Loc   = 1'b1;
				Reg2Write = 1'b0;
			end
			
			LDUR: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b0;
				UncondBr  = 1'bX;
				BrTaken   = 2'b00;
				MemWrite  = 1'b0;
				MemRead	 = 1'b1;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b01;
				ALUSrc    = 2'b10;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'b0;
			end
			
			STUR: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b0;
				UncondBr  = 1'bX;
				BrTaken   = 2'b00;
				MemWrite  = 1'b1;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'b10;
				Reg2Loc   = 1'b0;
				Reg2Write = 1'b0;
			end
			
		endcase
	end
endmodule
