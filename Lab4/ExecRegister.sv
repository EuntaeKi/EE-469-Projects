`timescale 1ns/10ps

module ExecRegister (clk, reset, 
                    ExPC, ExMem2Reg, ExBrTaken, ExRegWrite, ExMemWrite, 
                    ExMemRead, ExRn, ExRm, ExRd, ExDb, ExBranchPC, ExALUOut,
                    
                    MemPC, MemMem2Reg, MemBrTaken, MemRegWrite, MemMemWrite, 
                    MemMemRead, MemRn, MemRm, MemRd, MemDb, MemBranchPC, MemALUOut);
                    

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] ExPC, ExDb, ExALUOut, ExBranchPC;
    input  logic [4:0]  ExRn, ExRm, ExRd;
    input  logic [1:0]  ExMem2Reg, ExBrTaken;
    input  logic        ExMemWrite, ExMemRead, ExRegWrite;

    // Output Logic
    output logic [63:0] MemPC, MemDb, MemALUOut, MemBranchPC;
    output logic [4:0]  MemRn, MemRm, MemRd;
    output logic [1:0]  MemMem2Reg, MemBrTaken;
    output logic        MemMemWrite, MemMemRead, MemRegWrite;

    // Register Instantiation
    register64 ALUOutReg (.reset, .clk, .write(1'b1), .in(ExALUOut), .out(MemALUOut));
    register64 BrPCReg (.reset, .clk, .write(1'b1), .in(ExBranchPC), .out(MemBranchPC));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(ExDb), .out(MemDb));
	 register64 PCReg (.reset, .clk, .write(1'b1), .in(ExPC), .out(MemPC));
	 
    // Register Address Register Instantiation
    registerN #(.N(5)) RnReg (.reset, .clk, .in(ExRn), .out(MemRn));
    registerN #(.N(5)) RmReg (.reset, .clk, .in(ExRm), .out(MemRm));
    registerN #(.N(5)) RdReg (.reset, .clk, .in(ExRd), .out(MemRd));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(ExMem2Reg), .out(MemMem2Reg));
	 registerN #(.N(2)) BrTakenReg (.reset, .clk, .in(ExBrTaken), .out(MemBrTaken));

    D_FF MemWriteReg (.q(MemMemWrite), .d(ExMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(MemMemRead), .d(ExMemRead), .reset, .clk);
    D_FF RegWriteReg (.q(MemRegWrite), .d(ExRegWrite), .reset, .clk);

endmodule