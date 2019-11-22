`timescale 1ns/10ps

module InstructionDecode (clk, reset, Reg2Loc, RegWrite, ALUSrc, Dw, Instruction, Da, Db, MemAddr9Ext, Imm12Ext);
    // Input Logic (clk & Control Signals)
    input  logic        clk, reset, Reg2Loc, RegWrite;
    input  logic [1:0]  ALUSrc;
    input  logic [63:0] Dw;

    // ID Instruction
    input  logic [31:0] Instruction;

    // Register Data Output
    output logic [63:0] DecDa, DecDb;

    // Extended Constants
    output logic [63:0] MemAddr9Ext, Imm12Ext;

    // Intermediate Logic (Register Data)
    logic [63:0] Db;


    /* Register File for the CPU 
     * ReadData1 = DecDa, ReadData2 = Db, WriteData = Dw
     * Regfile will be updated at WB stage
     * RegWrite will signal whether or not it's ID or WB stage
     */
    regfile RegisterFile (.ReadData1(DecDa), .ReadData2(Db), .WriteData(Dw)
                        , .ReadRegister1(Instruction[9:5]), .ReadRegister2(Instruction[4:0]), .WriteRegister(Instruction[20:16])
                        , .RegWrite, .clk);

    // Imm12Ext
	// Zero Extended Instruction[21:10] when used
	SignExtend #(.N(13)) ExtendImm12 (.in({1'b0, Instruction[21:10]}), .out(Imm12Ext));
	
	// MemAddr9Ext
	// Sign Extended Instruction[20:12] when used
	SignExtend #(.N(9)) ExtendImmMem (.in(Instruction[20:12]), .out(MemAddr9Ext));

    // ALUSrc Mux
	mux4to1_64bit MuxALUSrc (.select(ALUSrc), .in({64'bx, MemAddr9Ext, Imm12Ext, Db}), .out(DecDb));

endmodule
	
