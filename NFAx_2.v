`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 10:33:04 PM
// Design Name: 
// Module Name: NFAx_2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module NFAx(
    input a,
    input b,
    input c,
    output sum,
    output carry
);
    // S? d?ng XOR cho Sum ?? tránh l?i bão hòa (Saturation Error) khi c = 0
    assign sum   = a ^ b ^ c; 
    
    // Carry x?p x? ?? ti?t ki?m c?ng logic
    assign carry = a & b; 
endmodule