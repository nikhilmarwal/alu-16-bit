module carry_look_ahead_generator (
    input  [3:0] A,
    input  [3:0] B,
    input        C0,
    output       C1, C2, C3, C4
);

    wire [3:0] G, P;

    assign P = A ^ B;
    assign G = A & B;

    assign C1 = G[0] | (P[0] & C0);
    assign C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C0);
    assign C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C0);
    assign C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) |
                (P[3] & P[2] & P[1] & G[0]) |
                (P[3] & P[2] & P[1] & P[0] & C0);

endmodule
