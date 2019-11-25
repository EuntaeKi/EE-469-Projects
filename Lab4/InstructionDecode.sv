`timescale 1ns/10ps

module InstructionDecode (clk, reset, DecReg2Loc, DecRegWrite, DecReg2Write, DecDw, Instruction, DecDa, DecDb, DecAa, DecAb, DecAw, DecMemAddr9Ext, DecImm12Ext);
    // Input Logic (clk & Control Signals)
    input  logic        clk, reset, DecReg2Loc, DecRegWrite, DecReg2Write;
    input  logic [63:0] DecDw;
    input  logic [31:0] Instruction;

    // Output Logic (Register Data , Register Address, Signed-extended constants)
    output logic [63:0] DecDa, DecDb;
    output logic [4:0] DecAa, DecAb, DecAw;
    output logic [63:0] DecMemAddr9Ext, DecImm12Ext;

    // Intermediate Logic (Register Data)
    logic [63:0] Db;


	// Reg2Write Mux
	// Determines which register address gets used for Aw in the register file (Rd or X30)
	mux2to1_Nbit #(.N(5)) MuxReg2Write (.en(DecReg2Write), .a(Instruction[4:0]), .b(5'd30), .out(DecAw));

    // Reg2Loc Mux
	// Determines which register address gets used for Ab in the register file (Rd or Rm)
	mux2to1_Nbit #(.N(5)) MuxReg2Loc (.en(DecReg2Loc), .a(Instruction[4:0]), .b(Instruction[20:16]), .out(DecAb));

    /* Register File for the CPU 
     * ReadData1 = DecDa, ReadData2 = Db, WriteData = Dw
     * Regfile will be updated at WB stage
     * RegWrite will signal whether or not it's ID or WB stage
     */
    regfile RegisterFile (.ReadData1(DecDa), .ReadData2(Db), .WriteData(DecDw)
                        , .ReadRegister1(Instruction[9:5]), .ReadRegister2(DecAb), .WriteRegister(DecAw)
                        , .RegWrite(DecRegWrite), .clk);

    // Imm12Ext
	// Zero Extended Instruction[21:10] when used
	SignExtend #(.N(13)) ExtendImm12 (.in({1'b0, Instruction[21:10]}), .out(DecImm12Ext));
	
	// MemAddr9Ext
	// Sign Extended Instruction[20:12] when used
	SignExtend #(.N(9)) ExtendImmMem (.in(Instruction[20:12]), .out(DecMemAddr9Ext));

    assign DecDa = Instruction[9:5];
endmodule
	
