`timescale 1ns/10ps

module InstructionDecode (clk, reset, DecInst, DecReg2Loc, DecReg2Write, DecUncondBr, WbMemDataToReg, WbRegWrite, DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch);

    // Input Logic (clk & Control Signals)
    input  logic        clk, reset, DecReg2Loc, DecUncondBr, WbRegWrite, DecReg2Write;
    input  logic [63:0] WbMemDataToReg;
    input  logic [31:0] DecInst;

    // Output Logic (Register Data , Register Address, Signed-extended constants)
    output logic [63:0] DecDa, DecDb;
    output logic [4:0]  DecAa, DecAb, DecAw;
    output logic [63:0] DecImm9Ext, DecImm12Ext, DecImmBranch;
	 
	// Reg2Write Mux
	// Determines which register address gets used for Aw in the register file (Rd or X30)
	mux2to1_Nbit #(.N(5)) MuxReg2Write (.en(DecReg2Write), .a(DecInst[4:0]), .b(5'd30), .out(DecAw));

    // Reg2Loc Mux
	// Determines which register address gets used for Ab in the register file (Rd or Rm)
	mux2to1_Nbit #(.N(5)) MuxReg2Loc (.en(DecReg2Loc), .a(DecInst[4:0]), .b(DecInst[20:16]), .out(DecAb));

    /* Register File for the CPU 
     * ReadData1 = DecDa, ReadData2 = Db, WriteData = Dw
     * Regfile will be updated at WB stage
     * RegWrite will signal whether or not it's ID or WB stage
     */
    regfile RegisterFile (.ReadData1(DecDa), .ReadData2(DecDb), .WriteData(WbMemDataToReg)
                        , .ReadRegister1(DecInst[9:5]), .ReadRegister2(Ab), .WriteRegister(Aw)
                        , .RegWrite(WbRegWrite), .clk);

    // Imm12Ext
	// Zero Extended DecInst[21:10] when used
	SignExtend #(.N(13)) ExtendImm12 (.in({1'b0, DecInst[21:10]}), .out(DecImm12Ext));
	
	// MemAddr9Ext
	// Sign Extended DecInst[20:12] when used
	SignExtend #(.N(9)) ExtendImmMem (.in(DecInst[20:12]), .out(DecImm9Ext));

	logic [63:0] brAddrExt, condAddrExt;
	SignExtend #(.N(26)) ExtendBrAddr (.in(DecInst[25:0]), .out(brAddrExt));
	SignExtend #(.N(19)) ExtendCondAddr (.in(DecInst[18:0]), .out(condAddrExt));
	
	mux2to1_64bit theUncondMux (.select(DecUncondBr), .in({condAddrExt, brAddrExt}), .out(DecImmBranch));
endmodule
	
