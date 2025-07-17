module adder_subtractor_4bit(
    input [3:0] A,
    input [3:0] B,
    input mode, 
    input c_in,
    output [3:0] S,
    output C_out
);

wire [3:0] B_mod; 
wire [3:0] P;
wire C1,C2,C3,C4; 


assign B_mod = B ^ {4{mode}};
assign P = A ^ B_mod;

carry_look_ahead_generator CL(
    .A(A),
    .B(B_mod),
    .C0(c_in),
    .C1(C1),
    .C2(C2),
    .C3(C3),
    .C4(C_out)
);

assign S[0] = P[0] ^ c_in;
assign S[1] = P[1] ^ C1;
assign S[2] = P[2] ^ C2;
assign S[3] = P[3] ^ C3;
endmodule
