`timescale 1ns/10ps

module DecodeRegister (clk, reset, DecDa, DecDb, DecALUOp, DecMem2Reg, DecMemWrite, DecMemRead, DecFlagWrite, DecRegWrite DecMemAddr9Ext, DecImm12Ext, 
                        ExDa, ExDb, ExALUOp, ExMem2Reg, ExMemWrite, ExMemRead, ExFlagWrite, ExRegWrite, ExMemAddr9Ext, ExImm12Ext);

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] DecDa, DecDb, DecMemAddr9Ext, DecImm12Ext;
    input  logic [2:0]  DecALUOp;
    input  logic [1:0]  DecMem2Reg;
    input  logic        DecMemWrite, DecMemRead, DecFlagWrite, DecRegWrite;
    
    // Output Logic
    output logic [63:0] ExDa, ExDb, ExMemAddr9Ext, ExImm12Ext;
    output logic [2:0]  ExALUOp;
    output logic [1:0]  ExMem2Reg;
    output logic        ExMemWrite, ExMemRead, ExFlagWrite, ExRegWrite;

    // Register Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            ExDa <= 64'b0;
            ExDb <= 64'b0;
            ExALUOp <= 0;
            ExMem2Reg <= 0;
            ExMemWrite <= 0;
            ExMemRead <= 0;
            ExFlagWrite <= 0;
            ExRegWrite <= 0;
            ExMemAddr9Ext <= 64'b0;
            ExImm12Ext <= 64'b0;
        end else begin
            ExDa <= DecDa;
            ExDb <= DecDb;
            ExALUOp <= DecALUOp;
            ExMem2Reg <= DecMem2Reg;
            ExMemWrite <= DecMemWrite;
            ExMemRead <= DecMemRead;
            ExFlagWrite <= DecFlagWrite;
            ExRegWrite <= DecRegWrite;
            ExMemAddr9Ext <= DecMemAddr9Ext;
            ExImm12Ext <= DecImm12Ext;
        end
    end
endmodule