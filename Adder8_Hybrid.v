`timescale 1ns/1ps

module Adder8_Hybrid #(
    parameter USE_APPROX = 1
)(
    input  wire [7:0] x,
    input  wire [7:0] y,
    output wire [7:0] sum
);

    wire [8:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : ADDERS
            if (USE_APPROX && i < 2) begin : APPROX_PART
                NFAx fa (
                    .a   (x[i]),
                    .b   (y[i]),
                    .cin (carry[i]),
                    .sum (sum[i]),
                    .cout(carry[i+1])
                );
            end
            else begin : EXACT_PART
                Exact_FA fa (
                    .a   (x[i]),
                    .b   (y[i]),
                    .cin (carry[i]),
                    .sum (sum[i]),
                    .cout(carry[i+1])
                );
            end
        end
    endgenerate

endmodule