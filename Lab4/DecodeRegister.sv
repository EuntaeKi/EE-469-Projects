`timescale 1ns/10ps

module DecodeRegister (clk, reset, 
                        DecPC, DecALUOp, DecALUSrc, DecMem2Reg, DecBrTaken, 
                        DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead, DecRn,
                        DecRm, DecRd, DecDa, DecDb, DecImm12Ext, DecImm9Ext, DecImmBranch,

                        ExPC, ExALUOp, ExALUSrc, ExMem2Reg, ExBrTaken, 
                        ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead, ExRn, 
                        ExRm, ExRd, ExDa, ExDb, ExImm12Ext, ExImm9Ext, ExImmBranch)

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] DecPC, DecDa, DecDb, DecImm9Ext, DecImm12Ext, DecImmBranch;
    input  logic [4:0]  DecRn, DecRm, DecRd;
    input  logic [2:0]  DecALUOp;
    input  logic [1:0]  DecMem2Reg, DecALUSrc, DecBrTaken;
    input  logic        DecMemWrite, DecMemRead, DecFlagWrite, DecRegWrite, DecReg2Write;
    
    // Output Logic
    output logic [63:0] ExPC, ExDa, ExDb, ExImm9Ext, ExImm12Ext, ExImmBranch;
    output logic [4:0]  ExRn, ExRm, ExRd;
    output logic [2:0]  ExALUOp;
    output logic [1:0]  ExMem2Reg, ExALUSrc, ExBrTaken;
    output logic        ExMemWrite, ExMemRead, ExFlagWrite, ExRegWrite, ExReg2Write;

    // Register Instantiation
    register64 PCReg (.reset, .clk, .write(1'b1), .in(DecPC), .out(ExPC));
    register64 DaReg (.reset, .clk, .write(1'b1), .in(DecDa), .out(ExDa));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(DecDb), .out(ExDb));
    register64 Imm9Reg (.reset, .clk, .write(1'b1), .in(DecImm9Ext), .out(ExImm9Ext));
    register64 Imm12Reg (.reset, .clk, .write(1'b1), .in(DecImm12Ext), .out(ExImm12Ext));
    register64 ImmBranchReg (.reset, .clk, .write(1'b1), .in(DecImmBranch), .out(ExImmBranch));

    // Register Address Registers
    registerN #(.N(5)) RnReg (.reset, .clk, .in(DecRn), .out(ExRn));
    registerN #(.N(5)) RmReg (.reset, .clk, .in(DecRm), .out(ExRm));
    registerN #(.N(5)) RdReg (.reset, .clk, .in(DecRd), .out(ExRd));

    // Control Logic Registers (n-bits)
    registerN #(.N(3)) ALUOpReg (.reset, .clk, .in(DecALUOp), .out(ExALUOp));
    registerN #(.N(2)) ALUSrcReg (.reset, .clk, .in(DecALUSrc), .out(ExALUSrc));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(DecMem2Reg), .out(ExMem2Reg));
    registerN #(.N(2)) BrTakenReg (.reset, .clk, .in(DecBrTaken), .out(ExBrTaken));

    // Control Logic Registers (1-bit)
    D_FF MemWriteReg (.q(ExMemWrite), .d(DecMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(ExMemRead), .d(DecMemRead), .reset, .clk);
    D_FF FlagWriteReg (.q(ExFlagWrite), .d(DecFlagWrite), .reset, .clk);
    D_FF RegWriteReg (.q(ExRegWrite), .d(DecRegWrite), .reset, .clk);
    D_FF Reg2WriteReg (.q(ExReg2Write), .d(DecReg2Write), .reset, .clk);
    
endmodule