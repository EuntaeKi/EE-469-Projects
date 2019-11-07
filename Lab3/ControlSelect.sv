module CPUcontrol (CondAddr19, BrAddr26, UncondBr, BrTaken, clk, reset, opCode);
	input logic [18:0] CondAddr19;
	input logic [25:0] BrAddr26;
	input logic clk, reset, UncondBr, BrTaken;
	logic [63:0] condAddr, condAddrEx, brAddrEx, shiftedCond, BrAddr, PC, updatedPC;
	output logic [31:0] opCode;
	
	MUX64_2_1 condMUX (.a(condAddrEx), .b(brAddrEx), .en(UncondBr), .out(condAddr));
	MUX2_1 brMUX (.a(updatedPC + 3'b100), .b(brAddr), .en(BrTaken), .out(updatedPC));
	signExtend cond (.in(CondAddr19), .out(condAddrEx));
	signExtend brCond (.in(BrAddr26), .out(brAddrEx));
	shifter shift (.value(condAddr), .direction(1'b0), .distance(5'b00010), .result(shiftedCond));
	fullAdder_64 add (.a(PC), .b(shiftedCond), .out(BrAddr));
	programCounter pc (.in(updatedPC), .clk, .reset, .out(PC));
	instructmem instmem (.address(PC), .instruction(opCode), .clk);	
endmodule 