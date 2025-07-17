module alu_4bit(
    input [3:0]A,
    input [3:0]B,
    input [2:0]opcode,
    input c_in,
    output reg [3:0] result,
    output wire c_out
);


wire add_sub_C_out;
wire [3:0]sum;


//instantiation of 4 bit adder and subtractor 
adder_subtractor_4bit Adder(
    .A(A),
    .B(B),
    .mode(opcode[0]),
    .c_in(c_in),
    .S(sum),
    .C_out(add_sub_C_out)
);


wire A_and_B = A & B;
wire A_or_B = A | B;
wire empty = 0;



always @(*) begin
    case(opcode)  
        3'b000 : begin
            result = sum; //does ADDITION
        end
        3'b001 : begin
            result = sum; //does SUBTRACTION
        end
        3'b010 : result = A & B; //does and operation
        3'b011 : result = A | B; //does or operation
        3'b100 : begin
            result = 4'b0000;
        end
        3'b101 : begin 
            result = 4'b0000;
        end
        3'b110 : begin 
            result = 4'b0000;
        end
        default: begin 
            
        end
    endcase  
end

assign c_out = (opcode == 3'b000 || opcode == 3'b001) ? add_sub_C_out : 1'b0;
endmodule 