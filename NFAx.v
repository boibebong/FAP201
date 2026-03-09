module NFAx(
    input a,
    input b,
    input c,
    output sum,
    output carry
);
    // Thi?t k? bám sát c?u trúc ph?n c?ng c?a AxSA
    // S? d?ng nguyên th?y (primitive) NAND và NOT ?? ép trình t?ng h?p m?ch
    // ??t ???c Delay c?c th?p (1.0 ??n v? tr?) thay vì dùng toán t? XOR.
    
    wire nand_ab;
    
    // 1. T?o tín hi?u NAND c?a a và b (Delay: 0.5)
    nand (nand_ab, a, b); 

    // 2. Logic Carry x?p x?: Carry = a & b
    // B?ng cách ??o ng??c tín hi?u nand_ab (Delay t?ng: 0.5 + 0.5 = 1.0)
    not (carry, nand_ab); 

    // 3. Logic Sum x?p x?: 
    // Theo tính ch?t x?p x? b?ng c?ng NAND ?? ??t delay 1.0
    nand (sum, nand_ab, c); 
    
endmodule