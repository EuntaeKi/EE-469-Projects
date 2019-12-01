`timescale 1ns/10ps

module DecodeRegister (clk, reset, 
                        DecIncrementedPC, DecALUOp, DecALUSrc, DecMem2Reg, 
                        DecRegWrite, DecMemWrite, DecMemRead, DecFlagWrite,
                        DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext,

                        ExIncrementedPC, ExALUOp, ExALUSrc, ExMem2Reg, 
                        ExRegWrite, ExMemWrite, ExMemRead, ExFlagWrite,
                        ExAw, ExDa, ExDb, ExImm12Ext, ExImm9Ext);

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] DecIncrementedPC, DecDa, DecDb, DecImm9Ext, DecImm12Ext;
    input  logic [4:0]  DecAw;
    input  logic [2:0]  DecALUOp;
    input  logic [1:0]  DecMem2Reg, DecALUSrc;
    input  logic        DecMemWrite, DecMemRead, DecRegWrite, DecFlagWrite;
    
    // Output Logic
    output logic [63:0] ExIncrementedPC, ExDa, ExDb, ExImm9Ext, ExImm12Ext;
    output logic [4:0]  ExAw;
    output logic [2:0]  ExALUOp;
    output logic [1:0]  ExMem2Reg, ExALUSrc;
    output logic        ExMemWrite, ExMemRead, ExRegWrite, ExFlagWrite;

    // Register Instantiation
    register64 PCReg (.reset, .clk, .write(1'b1), .in(DecIncrementedPC), .out(ExIncrementedPC));
    register64 DaReg (.reset, .clk, .write(1'b1), .in(DecDa), .out(ExDa));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(DecDb), .out(ExDb));
    register64 Imm9Reg (.reset, .clk, .write(1'b1), .in(DecImm9Ext), .out(ExImm9Ext));
    register64 Imm12Reg (.reset, .clk, .write(1'b1), .in(DecImm12Ext), .out(ExImm12Ext));

    // Register Address Registers
    registerN #(.N(5)) RdReg (.reset, .clk, .in(DecAw), .out(ExAw));

    // Control Logic Registers (n-bits)
    registerN #(.N(3)) ALUOpReg (.reset, .clk, .in(DecALUOp), .out(ExALUOp));
    registerN #(.N(2)) ALUSrcReg (.reset, .clk, .in(DecALUSrc), .out(ExALUSrc));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(DecMem2Reg), .out(ExMem2Reg));
	 
    // Control Logic Registers (1-bit)
    D_FF MemWriteReg (.q(ExMemWrite), .d(DecMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(ExMemRead), .d(DecMemRead), .reset, .clk);
    D_FF RegWriteReg (.q(ExRegWrite), .d(DecRegWrite), .reset, .clk);
    D_FF FlagWriteReg (.q(ExFlagWrite), .d(DecFlagWrite), .reset, .clk);

endmodule