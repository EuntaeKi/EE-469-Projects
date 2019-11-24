module Execute (clk, reset, ExDa, ExDb, ExALUOp, ExFlagWrite, ExNegative, ExCout, ExOverflow, ExZero, ExZeroInst, ExALUOutput);
    // Input Logic (Register Data)
    input  logic        clk, reset, ExFlagWrite;
    input  logic [2:0]  ExALUOp;
    input  logic [63:0] ExDa, ExDb;

    // Output Logic (Flag Data & ALU Output)
    output logic        ExNegative, ExCout, ExOverflow, ExZero, ExZeroInst;
    output logic [63:0] ExALUOutput;

    // Intermediate Logic (Flag Data)
    logic negative, zero, overflow, carry_out;


    // ALU Module - outputs the flags and perform operation depending on the ExALUOp
	alu TheAlu (.A(ExDa), .B(ExDb), .cntrl(ExALUOp), .result(ExALUOutput), .negative, .zero, .overflow, .carry_out);
	
	// Flag Register
	// cZero flag is updated immediately - others update with the clock.
	FlagReg TheFlagRegister (.clk, .reset, .enable(ExFlagWrite), .in({negative, carry_out, overflow, zero}), .out({ExNegative, ExCout, ExOverflow, ExZero}));
	assign ExZeroInst = zero;
endmodule