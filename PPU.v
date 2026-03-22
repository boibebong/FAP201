module PPU_signed_4bit(
    input  wire signed [3:0] a,
    input  wire signed [3:0] b,
    output wire signed [7:0] mult_result
);

    assign mult_result = a * b;

endmodule
