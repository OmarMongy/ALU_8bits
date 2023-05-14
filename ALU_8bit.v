module half_adder(
input x, y, 
output c , s
    );
    assign s = x ^ y;
    assign c = x & y;
    
endmodule
module full_adder(
input x, y ,c_in,
output c_out , s
    );
    wire c1 ,c2 , s1;
    
    half_adder HA1(
     .x(x),
     .y(y),
     .c(c1),
     .s(s1)
    );
    half_adder HA2(
         .x(c_in),
         .y(s1),
         .c(c2),
         .s(s)
        );
        
        assign c_out = c1 | c2;
        
endmodule

module rca_nbit
#(parameter n = 4)
    (
input [n-1 : 0] x ,y ,
input c_in ,
output [n-1 : 0] s,
output c_out
    );
    
    wire [n:0] c;
    assign c[0] = c_in;
    assign c_out = c[n];
    generate
       genvar k;
        for (k = 0 ;k < n; k = k+1 )
        begin : stage
        full_adder2 FA(
            .x(x[k]),
            .y(y[k]),
            .c_in(c[k]),
            .c_out(c[k+1]),
            .s(s[k])
            );
        end
    endgenerate
    
endmodule

module adder_subtractor_8bit(
input [7:0] x, y,
input add_n,
output [7:0] s,
output c_out
    );
    wire [7:0] xored_y;
       assign xored_y[0] = y[0] ^ add_n;
       assign xored_y[1] = y[1] ^ add_n;
       assign xored_y[2] = y[2] ^ add_n;
       assign xored_y[3] = y[3] ^ add_n;
       assign xored_y[4] = y[4] ^ add_n;
       assign xored_y[5] = y[5] ^ add_n;
       assign xored_y[6] = y[6] ^ add_n;
       assign xored_y[7] = y[7] ^ add_n;
         
    rca_nbit #(.n(8)) adder_8(
       .x(x),
       .y(xored_y),
       .c_in(add_n),
       .c_out(c_out),
       .s(s)
    );
    
    
endmodule
module ALU_8bit (
input [7:0] A, B,
input [2:0] opcode,
output reg [7:0]  ALU_output,
output C_flag , C_out
);
wire c_in ;
wire [7:0] Out;
assign c_in  = opcode[0];
adder_subtractor_8bit AS(
.x(A),
.y(B),
.add_n(opcode[0]),
.c_out(C_out),
.s(Out)
);
always @(*) begin
    case(opcode)
  3'b000 : ALU_output = Out;
  3'b001 : ALU_output = Out;
  3'b010 : ALU_output = A&B;
  3'b011 : ALU_output = A|B;
  3'b100 : ALU_output = A^B;
  3'b101 : ALU_output = (A > B) ? 8'b0000001 : 8'b0000000;
  3'b110 : ALU_output = A << 1;
  3'b111 : ALU_output = B << 1;
  endcase
            end
  assign C_flag = (A > B) ? 8'b0000001 : 8'b0000000;
endmodule
