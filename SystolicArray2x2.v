`timescale 1ns/1ps

module SystolicArray4x4_signed_approx_4bit #(
    parameter USE_APPROX = 1
)(
    input  wire              clk,
    input  wire              rst,
    input  wire              clear_acc,

    input  wire signed [3:0] a0_in,
    input  wire signed [3:0] a1_in,
    input  wire signed [3:0] a2_in,
    input  wire signed [3:0] a3_in,

    input  wire signed [3:0] b0_in,
    input  wire signed [3:0] b1_in,
    input  wire signed [3:0] b2_in,
    input  wire signed [3:0] b3_in,

    output wire signed [7:0] c00,
    output wire signed [7:0] c01,
    output wire signed [7:0] c02,
    output wire signed [7:0] c03,

    output wire signed [7:0] c10,
    output wire signed [7:0] c11,
    output wire signed [7:0] c12,
    output wire signed [7:0] c13,

    output wire signed [7:0] c20,
    output wire signed [7:0] c21,
    output wire signed [7:0] c22,
    output wire signed [7:0] c23,

    output wire signed [7:0] c30,
    output wire signed [7:0] c31,
    output wire signed [7:0] c32,
    output wire signed [7:0] c33
);

    // A-flow wires: truy?n ngang
    wire signed [3:0] a00_01, a01_02, a02_03;
    wire signed [3:0] a10_11, a11_12, a12_13;
    wire signed [3:0] a20_21, a21_22, a22_23;
    wire signed [3:0] a30_31, a31_32, a32_33;

    // B-flow wires: truy?n d?c
    wire signed [3:0] b00_10, b10_20, b20_30;
    wire signed [3:0] b01_11, b11_21, b21_31;
    wire signed [3:0] b02_12, b12_22, b22_32;
    wire signed [3:0] b03_13, b13_23, b23_33;

    // Row 0
    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe00 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a0_in),   .b_in(b0_in),
        .a_out(a00_01), .b_out(b00_10), .sum_out(c00)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe01 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a00_01),  .b_in(b1_in),
        .a_out(a01_02), .b_out(b01_11), .sum_out(c01)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe02 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a01_02),  .b_in(b2_in),
        .a_out(a02_03), .b_out(b02_12), .sum_out(c02)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe03 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a02_03), .b_in(b3_in),
        .a_out(),      .b_out(b03_13), .sum_out(c03)
    );

    // Row 1
    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe10 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a1_in),   .b_in(b00_10),
        .a_out(a10_11), .b_out(b10_20), .sum_out(c10)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe11 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a10_11),  .b_in(b01_11),
        .a_out(a11_12), .b_out(b11_21), .sum_out(c11)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe12 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a11_12),  .b_in(b02_12),
        .a_out(a12_13), .b_out(b12_22), .sum_out(c12)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe13 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a12_13), .b_in(b03_13),
        .a_out(),      .b_out(b13_23), .sum_out(c13)
    );

    // Row 2
    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe20 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a2_in),   .b_in(b10_20),
        .a_out(a20_21), .b_out(b20_30), .sum_out(c20)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe21 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a20_21),  .b_in(b11_21),
        .a_out(a21_22), .b_out(b21_31), .sum_out(c21)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe22 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a21_22),  .b_in(b12_22),
        .a_out(a22_23), .b_out(b22_32), .sum_out(c22)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe23 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a22_23), .b_in(b13_23),
        .a_out(),      .b_out(b23_33), .sum_out(c23)
    );

    // Row 3
    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe30 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a3_in),   .b_in(b20_30),
        .a_out(a30_31), .b_out(), .sum_out(c30)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe31 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a30_31),  .b_in(b21_31),
        .a_out(a31_32), .b_out(), .sum_out(c31)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe32 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a31_32),  .b_in(b22_32),
        .a_out(a32_33), .b_out(), .sum_out(c32)
    );

    PE_MAC_signed_approx_4bit #(.USE_APPROX(USE_APPROX)) pe33 (
        .clk(clk), .rst(rst), .clear_acc(clear_acc),
        .a_in(a32_33), .b_in(b23_33),
        .a_out(),      .b_out(), .sum_out(c33)
    );

endmodule
