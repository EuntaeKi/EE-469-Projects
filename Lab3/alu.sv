`timescale 1ns/10ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
input logic [2:0] cntrl;
input logic [63:0] A, B;
output logic negative, zero, overflow, carry_out;
output logic [63:0] result;
logic [63:0] coutHold;
logic [3:0] norHold;
logic subtract, subEn;

and #0.05 sub (subEn, cntrl[0], cntrl[1]);
MUX2_1 m0 (.a(1'b0), .b(1'b1), .en(subEn), .out(subtract));
aluBit a0 (.a(A[0]), .b(B[0]), .cin(subtract), .aluOp(cntrl), .out(result[0]), .cout(coutHold[0]));
genvar i;
generate
for (i = 1; i < 64; i++) begin: eachALU
aluBit a (.a(A[i]), .b(B[i]), .cin(coutHold[i-1]), .aluOp(cntrl), .out(result[i]), .cout(coutHold[i]));
end
endgenerate

assign carry_out = coutHold[63];
xor #0.05 x0 (overflow, coutHold[63], coutHold[62]);
assign negative = result[63];
nor16_1 n0 (.in(result[15:0]), .out(norHold[0]));
nor16_1 n1 (.in(result[31:16]), .out(norHold[1]));
nor16_1 n2 (.in(result[47:32]), .out(norHold[2]));
nor16_1 n3 (.in(result[63:48]), .out(norHold[3]));
and #0.05 andNors (zero, norHold[3], norHold[2], norHold[1], norHold[0]);
endmodule

// Test bench for ALU


// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl Operation Notes:
// 000: result = B value of overflow and carry_out unimportant
// 010: result = A + B
// 011: result = A - B
// 100: result = bitwise A & B value of overflow and carry_out unimportant
// 101: result = bitwise A | B value of overflow and carry_out unimportant
// 110: result = bitwise A XOR B value of overflow and carry_out unimportant
/*
module alustim();

parameter delay = 100000;

logic [63:0] A, B;
logic [2:0] cntrl;
logic [63:0] result;
logic negative, zero, overflow, carry_out ;

parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;


alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

// Force %t's to print in a nice format.
initial $timeformat(-9, 2, " ns", 10);

integer i;
logic [63:0] test_val;
initial begin

$display("%t testing PASS_A operations", $time);
cntrl = ALU_PASS_B;
for (i=0; i<100; i++) begin
A = $random(); B = $random();
#(delay);
assert(result == B && negative == B[63] && zero == (B == '0)); // Zero Test
end

$display("%t testing addition", $time);

cntrl = ALU_ADD; // Addition Test
A = 64'h0000000000000001; B = 64'h0000000000000001;
#(delay);
assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);

cntrl = ALU_SUBTRACT; // Subtract Test (Negative)
A = 64'h0000000000000000; B = 64'h0000000000000001;
#(delay);
assert(result == (A-B) && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);

cntrl = ALU_SUBTRACT;
// Negative overflow & Carry Out Detect
A = 64'h8000000000000000; B = 64'h8000000000000000;
#(delay);
assert(result == (A-B) && carry_out == 1 && overflow == 1 && negative == 0 && zero == 1);

cntrl = ALU_ADD;
A = 64'h7000000000000000; B = 64'h4000000000000000; // Positive overflow & Negative
#(delay);
assert(result == A + B && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);

cntrl = ALU_AND; // And Test (All 0)
A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000000;
#(delay);
assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);

A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; // And Test (All 1)
#(delay);
assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

cntrl = ALU_OR;
A = 64'h0; B = 64'h0; // Or Test (All 0)
#(delay);
assert(result == 64'h0 && negative == 0 && zero == 1);

A = 64'h0; B = 64'hFFFFFFFFFFFFFFFF; // Or Test (All 1)
#(delay);
assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; // Or Test (All 1)
#(delay);
assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

cntrl = ALU_XOR;
A = 64'h0; B = 64'h0; // Xor Test (All 0)
#(delay);
assert(result == 64'h0 && negative == 0 && zero == 1);

A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000000; // Xor Test (All 1)
#(delay);
assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

A = 64'h0; B = 64'hFFFFFFFFFFFFFFFF; // Xor Test (All 1)
#(delay);
assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; // Xor Test (All 0)
#(delay);
assert(result == 64'h0 && negative == 0 && zero == 1);
end
endmodule*/