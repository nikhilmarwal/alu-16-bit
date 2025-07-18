module test16bit();
reg [15:0] A;
reg [15:0] B;
reg c_in;
reg [2:0] opcode;

wire [15:0] result;
wire parity_check;
wire c_out;
wire [2:0] compare_out;
wire overflow;
wire [15:0] mul_high;
wire [15:0] mul_low;

integer pass_count = 0;
integer fail_count = 0;

alu_16bit BiggerAss(
    .A(A),
    .B(B),
    .c_in(c_in),
    .opcode(opcode),
    .result(result),
    .parity_check(parity_check),
    .c_out(c_out),
    .compare_result(compare_out),
    .overflow(overflow),
    .mul_high(mul_high),
    .mul_low(mul_low)
);

task result_check;
    input [15:0] expected_result;
    input [15:0] expected_mul_high;
    input [15:0] expected_mul_low;
    input expected_compare_gt_bit;
    input expected_compare_ls_bit;
    input expected_compare_eq_bit;
    input expected_overflow;
    input expected_parity;

    begin 
        if (result != expected_result || mul_high != expected_mul_high || mul_low != expected_mul_low || parity_check !=expected_parity || overflow != expected_overflow || compare_out[2] != expected_compare_ls_bit || compare_out[1] != expected_compare_gt_bit || compare_out[0] != expected_compare_eq_bit) begin
            $display("Fail Opcode : %b ,A : %b , B %b ,Result : %b(Expected result : %b) ,MUL_HIGH : %b(Expected Mul_high : %b) ,MUL_LOW : %b(Expected Mul Low : %b ) ,LT bit : %b (Expected LT bit: %b) ,GT bit : %b (Expected GT bit : %b) ,EQ bit :  %b (Expected eq Bit), Parity : %b(Expected Parity: %b) ,Overflow : %b(Expected Overflow : %b)", opcode, A, B, result, expected_result, mul_high, expected_mul_high,mul_low, expected_mul_low, compare_out[2], expected_compare_ls_bit, compare_out[1], expected_compare_gt_bit, compare_out[0], expected_compare_eq_bit,parity_check,expected_parity, overflow, expected_overflow);
            fail_count = fail_count + 1;
        end

        else begin
            $display("Test Passed Opcode : %b , A : %b , B : %b ",opcode,A,B) ;
            pass_count = pass_count +1;
        end
    end
endtask

reg [15:0] expected_result;
reg [15:0] expected_mul_high;
reg [15:0] expected_mul_low;
reg expected_compare_gt_bit;
reg expected_compare_ls_bit;
reg expected_compare_eq_bit;
reg expected_overflow;
reg expected_parity;
reg [31:0] mul_full;

reg [3:0] i, j, k;
reg [15:0] test_vectors [0:4];
initial begin
    test_vectors[0] = 16'h0000;
    test_vectors[1] = 16'hFFFF;
    test_vectors[2] = 16'h00FF;
    test_vectors[3] = 16'h0F0F;
    test_vectors[4] = 16'h8000;
    for(i=0;i<5;i++) begin
        A = test_vectors[i];
        for(j=0; j<5; j++) begin
            B = test_vectors[j];
            for(k = 0 ; k < 8 ; k++) begin
                opcode = k;
                expected_result = 16'b0;
                expected_compare_eq_bit = 1'b0;
                expected_compare_gt_bit = 1'b0;
                expected_compare_ls_bit = 1'b0;
                expected_mul_high = 16'b0;
                expected_mul_low = 16'b0;
                expected_parity = 1'b0;
                expected_overflow = 1'b0;
                #5;
                case (opcode)
                    3'b000 : expected_result = A + B;
                    3'b001 : expected_result = A - B;
                    3'b010 : expected_result = A & B;
                    3'b011 : expected_result = A | B;
                    3'b100 : expected_compare_eq_bit = (A == B);
                    3'b101 : expected_compare_gt_bit = (A > B);
                    3'b110 : expected_compare_ls_bit = (A < B);
                    3'b111 : begin
                        mul_full = A * B;
                        expected_mul_high = mul_full[31:16];
                        expected_mul_low = mul_full[15:0];
                    end
                    default : $display("The fuck you are trying to do nigga");
                endcase
                expected_parity = (opcode == 3'b111) ? ^{expected_mul_high, expected_mul_low} : ^expected_result;
                expected_overflow = (opcode <= 3'b001) ? ((A[15] == B[15]) && (expected_result[15] != A[15])) : 1'b0 ;
                
                result_check(expected_result, expected_mul_high, expected_mul_low,  expected_compare_gt_bit, expected_compare_ls_bit,  expected_compare_eq_bit, expected_overflow, expected_parity);
            end
        end
    end
    $display("Passed count %d",pass_count);
    $display("failed count %d",fail_count);
end

endmodule

        
    