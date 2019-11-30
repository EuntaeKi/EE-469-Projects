`timescale 1ns/10ps

module ForwardingUnit(DecAa, DecAb, DecAw, ExRd, MemRd, ExRegWrite, MemRegWrite, ForwardA, ForwardB);
	input  logic [4:0] DecAa, DecAb, DecAw, ExRd, MemRd;
	input  logic       ExRegWrite, MemRegWrite;
	
	output logic [1:0] ForwardA, ForwardB; // 00 - no fwd, 01 - forward from Exec, 10 - forward from Mem
	
	always_comb begin
		if (ExRegWrite && (ExRd == DecAa) && (ExRd != 5'd31)) begin
			ForwardA = 2'b01;
		end
		// New value for Rn from WbReg output and not updated in MemReg
		else if (MemRegWrite && (MemRd != 5'd31) && (MemRd == DecAa) && (~ExRegWrite || (ExRd != DecAw) || (ExRd == 5'd31))) begin
			ForwardA = 2'b10;
		end
		// Mem has a new Rn value
		else begin
			ForwardA = 2'b00;
		end
		
		if (ExRegWrite && (ExRd == DecAb) && (ExRd != 5'd31)) begin
			ForwardB = 2'b01;
		end
		// New value for Rn from WbReg output and not updated in MemReg
		else if (MemRegWrite && (MemRd != 5'd31) && (MemRd == DecAb) && (~ExRegWrite || (ExRd != DecAw) || (ExRd == 5'd31))) begin
			ForwardB = 2'b10;
		end
		// Mem has a new Rn value
		else begin
			ForwardB = 2'b00;
		end
	end

endmodule 