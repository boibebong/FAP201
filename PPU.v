module PPU(
    input [7:0] c,
    input [7:0] d,
    output [63:0] pp_raw // Tr? v? 64 bits tích riêng l?
);
    genvar i, j;
    generate
        for (i=0; i<8; i=i+1) begin : row
            for (j=0; j<8; j=j+1) begin : col
                // C?ng NAND t?o tích riêng l? (Partial Product)
                and(pp_raw[i*8 + j], c[i], d[j]);
            end
        end
    endgenerate
endmodule