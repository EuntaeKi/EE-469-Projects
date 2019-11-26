`timescale 1ns/10ps

module Memory (clk, reset, address, MemWrite, MemRead, MemWriteData, MemOut);
    // Input logic (Memory Operation Signal & Address, Data)
    input  logic        clk, reset, MemWrite, MemRead;
    input  logic [63:0] address, MemWriteData;
    
    // Output Logic (Data in the memory)
    output logic [63:0] MemOut;

    datamem DataMemory (.address, .write_enable(MemWrite), .read_enable(MemRead), .write_data(MemWriteData), .clk, .xfer_size(4'b1000), .read_data(MemOut));

endmodule