module Exact_FA(
    input a,
    input b,
    input c_in,
    output sum,
    output c_out
);
    assign {c_out, sum} = a + b + c_in;
endmodule