`timescale 1ns/10ps

module ExecRegister (clk, reset, 
                    ExMem2Reg, ExBrTaken, ExRegWrite, ExMemWrite, 
                    ExMemRead, ExRn, ExRm, ExRd, ExDb, ExBrPC, ExALUOut,
                    
                    MemMem2Reg, MemBrTaken, MemRegWrite, MemMemWrite, 
                    MemMemRead, MemRn, MemRm, MemRd, MemDb, MemBrPC, MemALUOut);

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] ExDb, ExALUOut, ExBrPC;
    input  logic [4:0]  ExRn, ExRm, ExRd;
    input  logic [1:0]  ExMem2Reg, ExBrTaken;
    input  logic        ExMemWrite, ExMemRead, ExRegWrite;

    // Output Logic
    output logic [63:0] MemDb, MemALUOut, MemBrPC;
    output logic [4:0]  MemRn, MemRm, MemRd;
    output logic [1:0]  MemMem2Reg, MemBrTaken;
    output logic        MemMemWrite, MemMemRead, MemRegWrite;

    // Register Instantiation
    register64 ALUOutReg (.reset, .clk, .write(1'b1), .in(ExALUOut), .out(MemALUOut));
    register64 BrPCReg (.reset, .clk, .write(1'b1), .in(ExBrPC), .out(MemBrPC));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(ExDb), .out(MemDb));

    // Register Address Register Instantiation
    registerN #(.N(5)) RnReg (.reset, .clk, .in(ExRn), .out(MemRn));
    registerN #(.N(5)) RmReg (.reset, .clk, .in(ExRm), .out(MemRm));
    registerN #(.N(5)) RdReg (.reset, .clk, .in(ExRd), .out(MemRd));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(ExMem2Reg), .out(MemMem2Reg));

    // Control Bit
    D_FF MemWriteReg (.q(MemMemWrite), .d(ExMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(MemMemRead), .d(ExMemRead), .reset, .clk);
    D_FF RegWriteReg (.q(MemRegWrite), .d(ExRegWrite), .reset, .clk);

endmodule