`timescale 1ns/10ps

module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input  logic [4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input  logic [63:0]	WriteData;
	input  logic 			RegWrite, clk;
	output logic [63:0]	ReadData1, ReadData2;
	
	logic [31:0] 		 registerWrite;
	logic [31:0][63:0] registerData;
	
	// The Decoder
	decoder5_32 writeDecoder (.in(WriteRegister[4:0]), .out(registerWrite[31:0]), .en(RegWrite));
	
	// The Registers	
	genvar i;
	generate
		for (i=0; i < 31; i++) begin : gen_registers
			register64 registers (.reset(1'b0), .clk(clk), .write(registerWrite[i]), .in(WriteData[63:0]), .out(registerData[i][63:0]));
		end
	endgenerate
	
	assign registerData[31][63:0] = 64'b0;
	
	// The Output Muxes
	mux32to1_64bit OutMux1 (.select(ReadRegister1[4:0]), .in(registerData), .out(ReadData1[63:0]));
	mux32to1_64bit OutMux2 (.select(ReadRegister2[4:0]), .in(registerData), .out(ReadData2[63:0]));
	
endmodule 