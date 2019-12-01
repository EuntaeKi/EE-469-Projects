`timescale 1ns/10ps

module ExecRegister (clk, reset, 
                    ExIncrementedPC, ExMem2Reg, ExRegWrite, ExMemWrite, 
                    ExMemRead, ExAw, ExDb, ExALUOut,
                    
                    MemIncrementedPC, MemMem2Reg, MemRegWrite, MemMemWrite, 
                    MemMemRead, MemAw, MemDb, MemALUOut);
                    

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] ExIncrementedPC, ExDb, ExALUOut;
    input  logic [4:0]  ExAw;
    input  logic [1:0]  ExMem2Reg;
    input  logic        ExMemWrite, ExMemRead, ExRegWrite;

    // Output Logic
    output logic [63:0] MemIncrementedPC, MemDb, MemALUOut;
    output logic [4:0]  MemAw;
    output logic [1:0]  MemMem2Reg;
    output logic        MemMemWrite, MemMemRead, MemRegWrite;

    // Register Instantiation
    register64 ALUOutReg (.reset, .clk, .write(1'b1), .in(ExALUOut), .out(MemALUOut));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(ExDb), .out(MemDb));
	 register64 PCReg (.reset, .clk, .write(1'b1), .in(ExIncrementedPC), .out(MemIncrementedPC));
	 
    // Register Address Register Instantiation
    registerN #(.N(5)) RnReg (.reset, .clk, .in(ExAw), .out(MemAw));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(ExMem2Reg), .out(MemMem2Reg));

    D_FF MemWriteReg (.q(MemMemWrite), .d(ExMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(MemMemRead), .d(ExMemRead), .reset, .clk);
    D_FF RegWriteReg (.q(MemRegWrite), .d(ExRegWrite), .reset, .clk);

endmodule