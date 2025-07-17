module multiplier_16bit(
    input [15:0] A,
    input [15:0] B,
    output [31:0] result
);

assign result = A*B;

endmodule