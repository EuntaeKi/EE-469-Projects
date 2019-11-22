module InstructionRegister (IFPC, IFInst, IDPC, IDInst, clk, reset);
    // Input Logics
    input  logic        clk, reset;
    input  logic [31:0] IFInst;
    input  logic [63:0] IFPC;

    // Output Logics
    output logic [31:0] IDInst;
    output logic [63:0] IDPC;

    // Register Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            IDInst <= 32'b0;
            IDPC <= 64'b0;
        end else begin
            IDInst <= IFInst;
            IDPC <= IFPC;
        end
    end
endmodule