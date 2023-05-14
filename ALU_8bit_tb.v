module ALU_8bit_DUT;

  // Define inputs and outputs
  reg [7:0] A, B;
  reg [2:0] opcode;
  wire [7:0] ALU_output;
  wire C_flag, C_out;

  // Instantiate the ALU
  ALU_8bit dut (
    .A(A),
    .B(B),
    .opcode(opcode),
    .ALU_output(ALU_output),
    .C_flag(C_flag),
    .C_out(C_out)
  );

  initial
  
 begin
    // Test case 1: Addition
    A = 8'd50;
    B = 8'd40;
    opcode = 3'b000;
    #10;  // Wait 10ns for the output to stabilize
    if (ALU_output !== 8'd90) $display("Test case 1 failed"); 
      
    // Test case 2: Subtraction
    A = 8'd50;
    B = 8'd40;
    opcode = 3'b001;
    #10;
   
      // Test case 3: Bitwise AND
    A = 8'b 0001_0111;
    B = 8'b 0001_1110;
    opcode = 3'b010;
    #10;
    if (ALU_output !== 8'b 0001_0110) $display("Test case 3 failed");

    // Test case 4: Bitwise OR
    A = 8'b 0100_0001;
    B = 8'b 0000_0010;
    opcode = 3'b011;
    #10;
    if (ALU_output !== 8'b 0100_0011) $display("Test case 4 failed");

    // Test case 5: Bitwise XOR
    A = 8'b 0010_0001;
    B = 8'b 0101_0011;
    opcode = 3'b100;
    #10;
    if (ALU_output !== 8'b0111_0010) $display("Test case 5 failed");

    // Test case 6: Comparison
    A = 8'd 10;
    B = 8'd 5;
    opcode = 3'b101;
    #10;
    if (ALU_output !== 8'b1 || C_flag !== 1'b1) $display("Test case 6 failed");

    // Test case 7: Shift left A
    A = 8'b 0000_1010;
    B = 8'b 0000_0101;
    opcode = 3'b110;
    #10;
    if (ALU_output !== 8'b 0001_0100) $display("Test case 7 failed");

    // Test case 8: Shift left B
    A = 8'b 0000_1010;
    B = 8'b 0000_0101;
    opcode = 3'b111;
    #10;
    if (ALU_output !== 8'b 0000_1010 ) $display("Test case 8 failed");
end
       
endmodule
