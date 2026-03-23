`timescale 1ns / 1ps
module NFAx(
    input a,
    input b,
    input c,
    output sum,
    output carry
);
    assign sum   = a ^ b ^ c; 
    assign carry = a & b; 
endmodule
