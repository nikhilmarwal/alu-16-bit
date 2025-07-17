module alu_16bit(
    input [15:0]A,
    input [15:0]B,
    input c_in,
    input [2:0] opcode,
    output [15:0] result,
    output reg [2:0] compare_result,
    output c_out,
    output reg overflow,
    output reg parity_check,
    output reg [15:0] mul_low,
    output reg [15:0] mul_high
);
wire c_out0 ,c_out1 ,c_out2;
wire A_eq_B, A_gt_B, A_lt_B;
reg true_cin;


alu_4bit a0(
    .A(A[3:0]),
    .B(B[3:0]),
    .c_in(true_cin),
    .result(result[3:0]),
    .c_out(c_out0),
    .opcode(opcode)
);

alu_4bit a1(
    .A(A[7:4]),
    .B(B[7:4]),
    .c_in(c_out0),
    .result(result[7:4]),
    .c_out(c_out1),
    .opcode(opcode)
);

alu_4bit a2(
    .A(A[11:8]),
    .B(B[11:8]),
    .c_in(c_out1),
    .result(result[11:8]),
    .c_out(c_out2),
    .opcode(opcode)
);

alu_4bit a3(
    .A(A[15:12]),
    .B(B[15:12]),
    .c_in(c_out2),
    .result(result[15:12]),
    .c_out(c_out),
    .opcode(opcode)
);

comparator_16bit cat(
    .A(A),
    .B(B),
    .A_eq_B(A_eq_B),
    .A_gt_B(A_gt_B),
    .A_lt_B(A_lt_B)
);


//multiplicator
wire [31:0] multi_out;

multiplier_16bit m(
    .A(A),
    .B(B),
    .result(multi_out)
);

 


always @ (*) begin  
    compare_result = 2'b0;
    overflow = (opcode <= 3'b001 ) ? (A[15] == B[15]) && (result[15] != A[15]) : 1'b0 ;//Logic for overflow if both the number have same msb but the result have opposite then this reprsent the overflow
    case (opcode)
        3'b000 : begin  // Addition 
            true_cin = 1'b0;
            parity_check = ^result;
            mul_low = 16'b0;
            mul_high = 16'b0;
            
        end
        3'b001 : begin  // subtraction
            true_cin = 1'b1;      //passing first c_in to be for subtraction
            parity_check = ^result;
            mul_low = 16'b0;
            mul_high = 16'b0;
        end
        3'b010 : begin
            parity_check = ^result;
            mul_high = 16'b0;
            mul_low = 16'b0;
        end
        3'b011 : begin
            parity_check = ^result;
            mul_high = 16'b0;
            mul_low = 16'b0;
        end
        3'b100 : begin //should do equlaity
            compare_result[0] = A_eq_B;
            parity_check = ^result;
            mul_high = 16'b0;
            mul_low = 16'b0;
        end
        3'b101 : begin  //should do greater than
            compare_result[1] = A_gt_B;
            parity_check = ^result;
            mul_high = 16'b0 ;
            mul_low = 16'b0;
        end
        3'b110 : begin //should do less than
            compare_result[2] = A_lt_B;
            parity_check = ^result;
            mul_high = 16'b0;
            mul_low = 16'b0;
        end
        3'b111 : begin
            mul_high = multi_out[31:16];
            mul_low = multi_out[15:0];
            parity_check = ^{mul_high,mul_low};
        end

        default : begin
            $display("Wrong opcode");
        end
    endcase
end

endmodule