module SystolicArray2x2(
    input clk,
    input [7:0] A00, A01, A10, A11,
    input [7:0] B00, B01, B10, B11,
    output [15:0] C00, C01, C10, C11
);

    wire [15:0] m00, m01, m10, m11;

    // C00 = A00*B00 + A01*B10
    PE pe00 (.a(A00), .b(B00), .in_sum(16'd0), .out_sum(m00));
    PE pe01 (.a(A01), .b(B10), .in_sum(m00), .out_sum(C00));

    // C01 = A00*B01 + A01*B11
    PE pe02 (.a(A00), .b(B01), .in_sum(16'd0), .out_sum(m01));
    PE pe03 (.a(A01), .b(B11), .in_sum(m01), .out_sum(C01));

    // C10 = A10*B00 + A11*B10
    PE pe10 (.a(A10), .b(B00), .in_sum(16'd0), .out_sum(m10));
    PE pe11 (.a(A11), .b(B10), .in_sum(m10), .out_sum(C10));

    // C11 = A10*B01 + A11*B11
    PE pe12 (.a(A10), .b(B01), .in_sum(16'd0), .out_sum(m11));
    PE pe13 (.a(A11), .b(B11), .in_sum(m11), .out_sum(C11));

endmodule