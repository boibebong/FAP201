`timescale 1ns/1ps

module PE_MAC_signed_approx_4bit #(
    parameter USE_APPROX = 1
)(
    input  wire              clk,
    input  wire              rst,
    input  wire              clear_acc,

    input  wire signed [3:0] a_in,
    input  wire signed [3:0] b_in,

    output reg  signed [3:0] a_out,
    output reg  signed [3:0] b_out,
    output reg  signed [7:0] sum_out
);

    wire signed [7:0] mult_result;
    wire [7:0] next_sum_unsigned;

    PPU_signed_4bit ppu_inst (
        .a(a_in),
        .b(b_in),
        .mult_result(mult_result)
    );

    Adder8_Hybrid #(
        .USE_APPROX(USE_APPROX)
    ) adder_inst (
        .x(sum_out),
        .y(mult_result),
        .sum(next_sum_unsigned)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_out   <= 4'sd0;
            b_out   <= 4'sd0;
            sum_out <= 8'sd0;
        end
        else begin
            a_out <= a_in;
            b_out <= b_in;

            if (clear_acc)
                sum_out <= 8'sd0;
            else
                sum_out <= $signed(next_sum_unsigned);
        end
    end

endmodule