`timescale 1ns/10ps

module DecodeRegister (clk, reset, 
                        DecPC, DecALUOp, DecALUSrc, DecMem2Reg, 
                        DecReg2Write, DecRegWrite, DecMemWrite, DecMemRead,
                        DecAa, DecAb, DecAw, DecDa, DecDb, DecImm12Ext, DecImm9Ext,

                        ExPC, ExALUOp, ExALUSrc, ExMem2Reg, 
                        ExReg2Write, ExRegWrite, ExMemWrite, ExMemRead, 
                        ExAa, ExAb, ExAw, ExDa, ExDb, ExImm12Ext, ExImm9Ext);

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] DecPC, DecDa, DecDb, DecImm9Ext, DecImm12Ext;
    input  logic [4:0]  DecAa, DecAb, DecAw;
    input  logic [2:0]  DecALUOp;
    input  logic [1:0]  DecMem2Reg, DecALUSrc;
    input  logic        DecMemWrite, DecMemRead, DecRegWrite, DecReg2Write;
    
    // Output Logic
    output logic [63:0] ExPC, ExDa, ExDb, ExImm9Ext, ExImm12Ext;
    output logic [4:0]  ExAa, ExAb, ExAw;
    output logic [2:0]  ExALUOp;
    output logic [1:0]  ExMem2Reg, ExALUSrc;
    output logic        ExMemWrite, ExMemRead, ExRegWrite, ExReg2Write;

    // Register Instantiation
    register64 PCReg (.reset, .clk, .write(1'b1), .in(DecPC), .out(ExPC));
    register64 DaReg (.reset, .clk, .write(1'b1), .in(DecDa), .out(ExDa));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(DecDb), .out(ExDb));
    register64 Imm9Reg (.reset, .clk, .write(1'b1), .in(DecImm9Ext), .out(ExImm9Ext));
    register64 Imm12Reg (.reset, .clk, .write(1'b1), .in(DecImm12Ext), .out(ExImm12Ext));

    // Register Address Registers
    registerN #(.N(5)) RnReg (.reset, .clk, .in(DecAa), .out(ExAa));
    registerN #(.N(5)) RmReg (.reset, .clk, .in(DecAb), .out(ExAb));
    registerN #(.N(5)) RdReg (.reset, .clk, .in(DecAw), .out(ExAw));

    // Control Logic Registers (n-bits)
    registerN #(.N(3)) ALUOpReg (.reset, .clk, .in(DecALUOp), .out(ExALUOp));
    registerN #(.N(2)) ALUSrcReg (.reset, .clk, .in(DecALUSrc), .out(ExALUSrc));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(DecMem2Reg), .out(ExMem2Reg));
	 
    // Control Logic Registers (1-bit)
    D_FF MemWriteReg (.q(ExMemWrite), .d(DecMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(ExMemRead), .d(DecMemRead), .reset, .clk);
    D_FF RegWriteReg (.q(ExRegWrite), .d(DecRegWrite), .reset, .clk);
    D_FF Reg2WriteReg (.q(ExReg2Write), .d(DecReg2Write), .reset, .clk);
    
endmodule