module Execute (clk, reset, ExDa, ExDb, ExALUOp, ExALUSrc, ExFlagWrite, ExMemAddr9Ext, ExImm12Ext, 
                ExNegative, ExCout, ExOverflow, ExZero, ExZeroInst, ExALUOutput);
    // Input Logic (Register Data)
    input  logic        clk, reset, ExFlagWrite;
    input  logic [2:0]  ExALUOp;
    input  logic [1:0]  ExALUSrc;
    input  logic [63:0] ExDa, ExDb, ExMemAddr9Ext, ExImm12Ext;

    // Output Logic (Flag Data & ALU Output)
    output logic        ExNegative, ExCout, ExOverflow, ExZero, ExZeroInst;
    output logic [63:0] ExALUOutput;

    // Intermediate Logic (Flag Data)
    logic negative, zero, overflow, carry_out;
    logic [63:0] ExDbb;



    // ALUSrc Mux
	mux4to1_64bit MuxALUSrc (.select(ExALUSrc), .in({64'bx, ExMemAddr9Ext, ExImm12Ext, ExDb}), .out(ExDbb));

    // ALU Module - outputs the flags and perform operation depending on the ExALUOp
	alu TheAlu (.A(ExDa), .B(ExDbb), .cntrl(ExALUOp), .result(ExALUOutput), .negative, .zero, .overflow, .carry_out);
	
	// Flag Register
	// cZero flag is updated immediately - others update with the clock.
	FlagReg TheFlagRegister (.clk, .reset, .enable(ExFlagWrite), .in({negative, carry_out, overflow, zero}), .out({ExNegative, ExCout, ExOverflow, ExZero}));
	assign ExZeroInst = zero;

endmodule