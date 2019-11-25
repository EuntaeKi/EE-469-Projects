module Execute (clk, reset, 
					ExDa, ExDb, ExALUSrc, ExBrTaken, ExALUOp, ExPC, ExImm12Ext, ExImm9Ext, 
					ExImmBranch, WbMemToRegData, MemALUResult, ForwardDa, ForwardDb,
					ExBrPC, ExALUOut, ExOverflow, ExNegative, ExZero, ExCarryout);
					
   // Input Logic
	input  logic [63:0] ExDa, ExDb, ExPC, ExImm12Ext, ExImm9Ext, ExImmBranch, WbMemToRegData, MemALUResult;
	input  logic [2:0]  ExALUOp;
   input  logic [1:0]  ExALUSrc, ExBrTaken, ForwardDa, ForwardDb;
   input  logic        clk, reset;


   // Output Logic (Flag Data & ALU Output)
	output logic [63:0] ExBrPc, ExALUOut;
	output logic 		  ExOverflow, ExNegative, ExZero, ExCarryout;

	// Forwarding
	logic [63:0] FwdDa, FwdDb;
	mux4to1_64bit ForwardingDaMux (.select(ForwardDa), .in({64'bx, WbMemToRegData, MemALUResult, ExDa}), .out(FwdDa));
	mux4to1_64bit ForwardingDaMux (.select(ForwardDb), .in({64'bx, WbMemToRegData, MemALUResult, ExDb}), .out(FwdDb));
	
	// ALUSrc
	logic [63:0] ALUSrcOut;
	mux4to1_64bit ALUSrcMux (.select(ExALUSrc), .in({64'bx, ExImm9Ext, ExImm12Ext, FwdDb}), .out(ALUSrcOut));
	
	// The ALU
	alu TheAlu (.A(FwdDa), .B(ALUSrcOut), .cntrl(ExALUOp), .result(ExALUOut), .negative(ExNegative), .zero(), .overflow(ExOverflow), .carry_out(ExCarryout));
	
	// Check if Db is zero for CBZ
	nor64 IsDbZero (.in(FwdDb), .out(ExZero));
	
	// Find next PC
	logic [63:0] shiftedAddr, branchedPC, noBranchPC;
	// If branched
	shifter TheShifter (.value(ExImmBranch), .direction(1'b0), .distance(6'b000010), .result(shiftedAddr));
	fullAdder_64 TheBranchAdder (.result(branchedPC), .A(ExPC), .B(shiftedAddr), .cin(1'b0), .cout());
	// If not branched
	fullAdder_64 advancePc (.result(noBranchPC), .A(ExPC), .B(64'd4), .cin(1'b0), .cout());
	// Branched MUX
	mux4to1_64bit TheBranchMux (.select(ExBrTaken), .in({64'b0, FwdDb, branchedPC, noBranchPC}), .out(ExBrPc));
endmodule 