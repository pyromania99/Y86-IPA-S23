module fetch (clk,PC, icode, ifun, rA, rB, valC ,valP, instr_valid, imem_err, hlt);

input clk;
input [63:0] PC;
output reg [3:0]  icode, ifun;
output reg [3:0]  rA,rB;
output reg [63:0] valP;
output reg [0:63] valC;
output reg instr_valid, imem_err, hlt;

reg [0:79] instruction; //this puts lsb -> msb so 0th bit is least significant
reg [7:0]  memory[0:100];//101 bytes

initial begin 
  //Instruction memory
 hlt = 0;
    memory[0]  = 8'b00010000; // nop instruction PC = PC +1 = 1
    memory[1]  = 8'b01100000; // Opq add
    memory[2]  = 8'b00000001; // rA = 0, rB = 1; PC = PC + 2 = 3

    memory[3]  = 8'b00110000; // irmovq instruction PC = PC + 10 = 13
    memory[4]  = 8'b11110010; // F, rB = 2;
    memory[5]  = 8'b11111111; // 1st byte of V = 255, rest all bytes will be zero
    memory[6]  = 8'b00000000; // 2nd byte
    memory[7]  = 8'b00000000; // 3rd byte
    memory[8]  = 8'b00000000; // 4th byte
    memory[9]  = 8'b00000000; // 5th byte
    memory[10] = 8'b00000000; // 6th byte
    memory[11] = 8'b00000000; // 7th byte
    memory[12] = 8'b00000000; // 8th byte (This completes irmovq)

    memory[13] = 8'b00110000; // irmovq instruction PC = PC + 10 = 23
    memory[14] = 8'b11110011; // F, rB = 3;
    memory[15] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    memory[16] = 8'b00000000; // 2nd byte
    memory[17] = 8'b00000000; // 3rd byte
    memory[18] = 8'b00000000; // 4th byte
    memory[19] = 8'b00000000; // 5th byte
    memory[20] = 8'b00000000; // 6th byte
    memory[21] = 8'b00000000; // 7th byte
    memory[22] = 8'b00000000; // 8th byte (This completes irmovq)

    memory[23] = 8'b00110000; // irmovq instruction PC = PC + 10 = 33
    memory[24] = 8'b11110100; // F, rB = 4;
    memory[25] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    memory[26] = 8'b00000000; // 2nd byte
    memory[27] = 8'b00000000; // 3rd byte
    memory[28] = 8'b00000000; // 4th byte
    memory[29] = 8'b00000000; // 5th byte
    memory[30] = 8'b00000000; // 6th byte
    memory[31] = 8'b00000000; // 7th byte
    memory[32] = 8'b00000000; // 8th byte (This completes irmovq)

    memory[33] = 8'b00100000; // rrmovq // PC = PC + 2 = 35
    memory[34] = 8'b01000101; // rA = 4; rB = 5; 

    memory[35] = 8'b01100000; // Opq add // PC = PC + 2 = 37
    memory[36] = 8'b00110100; // rA = 3 and rB = 4, final value in rB(4) = 10;

    memory[37] = 8'b00100101; // cmovge // PC = PC + 2 = 39
    memory[38] = 8'b01010110; // rA = 5; rB = 6;

    memory[39] = 8'b01100001; // Opq subq // PC = PC + 2 = 41
    memory[40] = 8'b00110101; // rA = 3, rB = 5; both are equal

    memory[41] = 8'b01110011; //je // PC = PC + 9 = 50
    memory[42] = 8'b00110100; // Dest = 52; 1st byte
    memory[43] = 8'b00000000; // 2nd byte
    memory[44] = 8'b00000000; // 3rd byte
    memory[45] = 8'b00000000; // 4th byte
    memory[46] = 8'b00000000; // 5th byte
    memory[47] = 8'b00000000; // 6th byte
    memory[48] = 8'b00000000; // 7th byte
    memory[49] = 8'b00000000; // 8th byte

    memory[50] = 8'b00010000; // nop 
    memory[51] = 8'b00010000; // nop

    memory[52] = 8'b01100000; // Opq add
    memory[53] = 8'b00110101; // rA = 3; rB = 5;

    memory[54] = 8'b00000000; // hlt 
  //main:

  end

always @*
begin
  imem_err=0;
  if (PC > 101) begin
   imem_err =1;
  end

  instruction = {
    memory[PC],
    memory[PC+1],
    memory[PC+2],
    memory[PC+3],
    memory[PC+4],
    memory[PC+5],
    memory[PC+6],
    memory[PC+7],
    memory[PC+8],
    memory[PC+9]
  };

  icode = instruction[0:3];
  ifun  = instruction[4:7];
  instr_valid = 1'd0;
  hlt = 64'd0;
  case(icode)

    //hlt
    4'h0  : begin
      hlt = 64'd1;
      valP= PC + 64'd1;
    end

    //nop
    4'h1	: valP= PC + 64'd1;

    /* cmovXX
      4'd0	: //rrmovq
      4'd1	: //cmovle
      4'd2	: //cmovl
      4'd3	: //cmove
      4'd4	: //cmovne
      4'd5	: //cmovge
      4'd6	: //cmovg */
    4'h2	: begin            
      rA = instruction[8:11];
      rB = instruction[12:15];
      valP =PC + 64'd2;
    end
    

    //irmovq
    4'h3	: begin
        rA = instruction[8:11];  // F
        rB = instruction[12:15]; 
        valC = {
          instruction[72:79],
          instruction[64:71],
          instruction[56:63],
          instruction[48:55],
          instruction[40:47],
          instruction[32:39],
          instruction[24:31],
          instruction[16:23]
        };
        valP = PC + 64'd10;
    end
    
    //rmmovq
    4'h4	: begin
      rA = instruction[8:11];
      rB = instruction[12:15]; 
      valC = {
        instruction[72:79],
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23]
      };
      valP = PC + 64'd10;
    end

    //mrmovq  
    4'h5	: begin
      rA = instruction[8:11];
      rB = instruction[12:15]; 
      valC = {
        instruction[72:79],
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23]
      };
      valP = PC + 64'd10;
    end 
    
    /* opq
      4'd0	: //addq
      4'd1	: //subq
      4'd2	: //andq
      4'd3	: //xorq
      end*/
    4'h6	: begin
        rA[3:0] = instruction[8:11];
        rB[3:0] = instruction[12:15];
        valP = PC + 64'd2;
    end
      
    
    /* jump
      4'd0	: //jmp
      4'd1	: //jle
      4'd2	: //jl
      4'd3	: //je
      4'd4	: //jne
      4'd5	: //jge
      4'd6	: //jg*/
    4'h7	: begin
      valC = {
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23],
        instruction[8:15]
      };
      valP = PC + 64'd9;
    end 

    //call
    4'h8	: begin
      valC = {
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23],
        instruction[8:15]
      };
      valP = PC + 64'd9;
    end 

    4'h9  : valP = PC + 64'd1;//ret

    //pushq
    4'hA  :  begin            
      rA = instruction[8:11];
      rB = instruction[12:15];
      valP =PC + 64'd2;
    end

    //popq
    4'hB  :  begin            
      rA = instruction[8:11];
      rB = instruction[12:15];
      valP =PC + 64'd2;
    end
    
    default : instr_valid = 1'd1;
  endcase
  
end
endmodule
