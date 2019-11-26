module Execute (clk, reset, 
					ExPC, ExDa, ExDb, ExALUSrc, ExBrTaken, ExALUOp, ExImm12Ext, ExImm9Ext, ExImmBranch,
					WbMemDataToReg, MemALUOut, ForwardDa, ForwardDb, ExBranchPC, ExFwdDb,
					ExALUOut, ExOverflow, ExNegative, ExZero, ExCarryout);
					
   // Input Logic
	input  logic [63:0] ExPC, ExDa, ExDb, ExImmBranch, ExImm12Ext, ExImm9Ext, WbMemDataToReg, MemALUOut;
	input  logic [2:0]  ExALUOp;
   input  logic [1:0]  ExALUSrc, ExBrTaken, ForwardDa, ForwardDb;
   input  logic        clk, reset;


   // Output Logic 
	output logic [63:0] ExBranchPC, ExALUOut, ExFwdDb;
	output logic 		  ExOverflow, ExNegative, ExZero, ExCarryout;

	// Forwarding
	logic [63:0] FwdDa;
	mux4to1_64bit ForwardingDaMux (.select(ForwardDa), .in({64'bx, WbMemDataToReg, MemALUOut, ExDa}), .out(FwdDa));
	mux4to1_64bit ForwardingDbMux (.select(ForwardDb), .in({64'bx, WbMemDataToReg, MemALUOut, ExDb}), .out(ExFwdDb));
	
	// ALUSrc
	logic [63:0] ALUSrcOut;
	mux4to1_64bit ALUSrcMux (.select(ExALUSrc), .in({64'bx, ExImm9Ext, ExImm12Ext, ExFwdDb}), .out(ALUSrcOut));
	
	// The ALU
	alu TheAlu (.A(FwdDa), .B(ALUSrcOut), .cntrl(ExALUOp), .result(ExALUOut), .negative(ExNegative), .zero(), .overflow(ExOverflow), .carry_out(ExCarryout));
	
	// Check if Db is zero for CBZ
	nor_64 CheckDbForZero (.in(ExFwdDb), .out(ExZero));
	
	logic [63:0] shiftedAddr;
	// If branched
	shifter TheShifter (.value(ExImmBranch), .direction(1'b0), .distance(6'b000010), .result(shiftedAddr));
	fullAdder_64 TheBranchAdder (.result(ExBranchPC), .A(ExPC), .B(shiftedAddr), .cin(1'b0), .cout());
endmodule 