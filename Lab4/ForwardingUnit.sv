`timescale 1ns/10ps

module ForwardingUnit(Forward2Da, Forward2Db, ExRd, ExRm, ExRn, MemRegWrite, MemRd, WbRegWrite, WbRd);
	input  logic [4:0] ExRd, ExRm, ExRn, MemRegWrite, MemRd, WbRd;
	input  logic       MemRegWrite, WbRegWrite;
	
	output logic [1:0] Forward2Da, Forward2Db; // 00 - no fwd, 01 - forward from Exec, 10 - forward from Mem
	
	always_comb begin
		// New value for Rn from Exec output
		if (MemRegWrite && (MemRd == ExRn) && (MemRd != 5'd31)) begin
			Forward2Da = 2'b01;
		end
		// New value for Rn from Mem output and not in 
		else if (WbRegWrite && (WbRd != 5'd31) && (WbRd == ExRn) && (~MemRegWrite || (MemRd != ExRn) || (MemRd == 5'd31))) begin
			Forward2Da = 2'b10;
		end
		// Mem has a new Rn value
		else begin
			Forward2Da = 2'b00;
		end
		
		// New value for Rm from Exec output
		if (MemRegWrite && (MemRd == ExRm) && (MemRd != 5'd31)) begin
			Forward2Da = 2'b01;
		end
		// New value for Rm from Mem output and not in Exec
		else if (WbRegWrite && (WbRd != 5'd31) && (WbRd == ExRm) && (~MemRegWrite || (MemRd != ExRm) || (MemRd == 5'd31))) begin
			Forward2Da = 2'b10;
		end
		// Mem has a new Rm value
		else begin
			Forward2Da = 2'b00;
		end
	end
endmodule 