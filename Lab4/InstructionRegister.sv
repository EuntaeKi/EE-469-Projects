module InstructionRegister (FetchPC, FetchInst, DecPC, DecInst, clk, reset);
    // Input Logics
    input  logic        clk, reset;
    input  logic [31:0] FetchInst;
	 input  logic [63:0] FetchPC;

    // Output Logics
    output logic [31:0] DecInst;
	 output logic [63:0] DecPC;

    // Register Instantiation
    registerN #(.N(32)) InstReg (.reset, .clk, .in(FetchInst), .out(DecInst));
	 registerN #(.N(64)) PCReg (.reset, .clk, .in(FetchPC), .out(DecPC));

endmodule