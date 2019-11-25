`timescale 1ns/10ps

module ExecRegister (clk, reset, ExDb, ExALUOutput, ExMem2Reg, ExMemWrite, ExMemRead, ExRegWrite,
                     MemDb, MemALUOutput, MemMem2Reg, MemMemWrite, MemMemRead, MemRegWrite);

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] ExDb, ExALUOutput;
    input  logic [1:0]  ExMem2Reg;
    input  logic        ExMemWrite, ExMemRead, ExRegWrite;

    // Output Logic (ExOutput)
    output logic [63:0] MemDb, MemALUOutput;
    output logic [1:0]  MemMem2Reg;
    output logic        MemMemWrite, MemMemRead, MemRegWrite;

    // Register Instantiation
    register64 ALUOutputReg (.reset, .clk, .write(1'b1), .in(ExALUOutput), .out(MemALUOutput));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(ExDb), .out(MemDb));

    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(ExMem2Reg), .out(MemMem2Reg));

    D_FF MemWriteReg (.q(MemMemWrite), .d(ExMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(MemMemRead), .d(ExMemRead), .reset, .clk);

endmodule