`timescale 1ns/10ps

module ForwardingUnit(DecAa, DecAb, ExAw, MemAw, ExRegWrite, MemRegWrite, ForwardA, ForwardB);
	input  logic [4:0] DecAa, DecAb, ExAw, MemAw;
	input  logic       ExRegWrite, MemRegWrite;
	
	output logic [1:0] ForwardA, ForwardB; // 00 - no fwd, 01 - forward from Exec, 10 - forward from Mem
	
	always_comb begin
		if (ExRegWrite && (ExAw == DecAa) && (ExAw != 5'd31)) begin
			ForwardA = 2'b01;
		end
		// New value for Rn from WbReg output and not updated in MemReg
		else if (MemRegWrite && (MemAw != 5'd31) && (MemAw == DecAa) && (~ExRegWrite || (ExAw != DecAa) || (ExAw == 5'd31))) begin
			ForwardA = 2'b10;
		end
		// Mem has a new Rn value
		else begin
			ForwardA = 2'b00;
		end
		
		if (ExRegWrite && (ExAw == DecAb) && (ExAw != 5'd31)) begin
			ForwardB = 2'b01;
		end
		// New value for Rn from WbReg output and not updated in MemReg
		else if (MemRegWrite && (MemAw != 5'd31) && (MemAw == DecAb) && (~ExRegWrite || (ExAw != DecAb) || (ExAw== 5'd31))) begin
			ForwardB = 2'b10;
		end
		// Mem has a new Rn value
		else begin
			ForwardB = 2'b00;
		end
	end

endmodule 