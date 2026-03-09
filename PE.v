module PE(
    input  [7:0] a,
    input  [7:0] b,
    input  [15:0] in_sum,
    output [15:0] out_sum
);

    wire [15:0] mult_result;
    wire [16:0] carry;

    assign mult_result = a * b;
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin : ADDER
            Exact_FA fa(
                .a(mult_result[i]),
                .b(in_sum[i]),
                .c_in(carry[i]),
                .sum(out_sum[i]),
                .c_out(carry[i+1])
            );
        end
    endgenerate

endmodule