module ExecRegister (clk, reset, DecDb, ExALUOutput, ExRegDecDb, ExRegALUOutput);
    // Input Logic
    input  logic        clk, reset;
    input  logic [63:0] ExALUOutput;

    // Output Logic (ExOutput)
    output logic [63:0] ExRegALUOutput;

    always_ff @(posedge clk) begin
        if (reset) begin
            ExRegALUOutput <= 64'b0;

        end begin else 
            ExRegALUOutput <= ExALUOutput;
        end
    end

endmodule