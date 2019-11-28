`timescale 1ns/10ps

module ForwardingUnit(ExAa, ExAb, ExAw, MemRd, WbRd, MemRegWrite, WbRegWrite, ForwardDa, ForwardDb);
	input  logic [4:0] ExAa, ExAb, ExAw, MemRd, WbRd;
	input  logic       MemRegWrite, WbRegWrite;
	
	output logic [1:0] ForwardDa, ForwardDb; // 00 - no fwd, 01 - forward from Exec, 10 - forward from Mem
	
	always_comb begin
		// New value for Rn from MemReg output
		if (MemRegWrite && (MemRd == ExAa) && (MemRd != 5'd31)) begin
			ForwardDa = 2'b01;
		end
		// New value for Rn from WbReg output and not updated in MemReg
		else if (WbRegWrite && (WbRd != 5'd31) && (WbRd == ExAa) && (~MemRegWrite || (MemRd != ExAw) || (MemRd == 5'd31))) begin
			ForwardDa = 2'b10;
		end
		// Mem has a new Rn value
		else begin
			ForwardDa = 2'b00;
		end
		
		// New value for Rm from Exec output
		if (MemRegWrite && (MemRd == ExAb) && (MemRd != 5'd31)) begin
			ForwardDb = 2'b01;
		end
		// New value for Rm from Mem output and not in Exec
		else if (WbRegWrite && (WbRd != 5'd31) && (WbRd == ExAb) && (~MemRegWrite || (MemRd != ExAb) || (MemRd == 5'd31))) begin
			ForwardDb = 2'b10;
		end
		// Mem has a new Rm value
		else begin
			ForwardDb = 2'b00;
		end
	end

endmodule 