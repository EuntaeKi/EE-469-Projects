module DecodeRegister (clk, reset, DecDa, DecDb, ExDa, ExDb, , DecMemAddr9Ext, DecImm12Ext, ExMemAddr9Ext, ExImm12Ext);
    // Input Logic
    input  logic [31:0] clk, reset;
    input  logic [63:0] DecDa, DecDb, DecMemAddr9Ext, DecImm12Ext;
    
    // Output Logic
    output logic [63:0] ExDa, ExDb, ExMemAddr9Ext, ExImm12Ext;

    // Register Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            ExDa <= 64'b0;
            ExDb <= 64'b0;
            ExMemAddr9Ext <= 64'b0;
            ExImm12Ext <= 64'b0;
        end else begin
            ExDa <= DecDa;
            ExDb <= DecDb;
            ExMemAddr9Ext <= ExMemAddr9Ext;
            ExImm12Ext <= DecImm12Ext;
        end
    end
endmodule