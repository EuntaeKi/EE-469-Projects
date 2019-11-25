`timescale 1ns/10ps

module DecodeRegister (clk, reset, DecDa, DecDb, DecALUOp, DecALUSrc, DecMem2Reg, DecMemWrite, DecMemRead, DecFlagWrite, DecRegWrite, DecMemAddr9Ext, DecImm12Ext, 
								ExDa, ExDb, ExALUOp, ExALUSrc, ExMem2Reg, ExMemWrite, ExMemRead, ExFlagWrite, ExRegWrite, ExMemAddr9Ext, ExImm12Ext);

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] DecDa, DecDb, DecMemAddr9Ext, DecImm12Ext;
    input  logic [2:0]  DecALUOp;
    input  logic [1:0]  DecMem2Reg, DecALUSrc;
    input  logic        DecMemWrite, DecMemRead, DecFlagWrite, DecRegWrite;
    
    // Output Logic
    output logic [63:0] ExDa, ExDb, ExMemAddr9Ext, ExImm12Ext;
    output logic [2:0]  ExALUOp;
    output logic [1:0]  ExMem2Reg, ExALUSrc;
    output logic        ExMemWrite, ExMemRead, ExFlagWrite, ExRegWrite;

    // Register Instantiation
    register64 ExDaReg (.reset, .clk, .write(1'b1), .in(DecDa), .out(ExDa));
    register64 ExDbReg (.reset, .clk, .write(1'b1), .in(DecDb), .out(ExDb));
    register64 ExMemAddrReg (.reset, .clk, .write(1'b1), .in(DecMemAddr9Ext), .out(ExMemAddr9Ext));
    register64 ExImmReg (.reset, .clk, .write(1'b1), .in(DecImm12Ext), .out(ExImm12Ext));

    registerN #(.N(3)) ALUOpReg (.reset, .clk, .in(DecALUOp), .out(ExALUOp));
    registerN #(.N(2)) ALUSrcReg (.reset, .clk, .in(DecALUSrc), .out(ExALUSrc));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(DecMem2Reg), .out(ExMem2Reg));

    D_FF MemWriteReg (.q(ExMemWrite), .d(DecMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(ExMemRead), .d(DecMemRead), .reset, .clk);
    D_FF FlagWriteReg (.q(ExFlagWrite), .d(DecFlagWrite), .reset, .clk);
    D_FF RegWriteReg (.q(ExRegWrite), .d(DecRegWrite), .reset, .clk);
    
endmodule