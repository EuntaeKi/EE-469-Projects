`timescale 1ns/10ps

module ExecRegister (clk, reset, ExDb, ExALUOutput, ExMem2Reg, ExMemWrite, ExMemRead, ExRegWrite,
                     MemDb, MemALUOutput, MemMem2Reg, MemMemWrite, MemMemRead, MemRegWrite);

    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] ExDb, ExALUOutput;
    input  logic [1:0]  ExMem2Reg;
    input  logic        ExMemWrite, ExMemRead;

    // Output Logic (ExOutput)
    output logic [63:0] MemDb, MemALUOutput;
    output logic [1:0]  MemMem2Reg;
    output logic        MemMemWrite, MemMemRead;

    always_ff @(posedge clk) begin
        if (reset) begin
            MemALUOutput <= 64'b0;
            MemDb <= 64'b0;
            MemMem2Reg <= 0;
            MemMemWrite <= 0;
            MemMemRead <= 0;
        end begin else 
            MemALUOutput <= ExALUOutput;
            MemDb <= ExDb;
            MemMem2Reg <= ExMem2Reg;
            MemMemWrite <= ExMemWrite;
            MemMemRead <= ExMemRead;
        end
    end

endmodule