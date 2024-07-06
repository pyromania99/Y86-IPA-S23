module select_PC(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_cnd, PC_new);

input clk;
input [63:0] F_predPC, W_valM, M_valA;
input [3:0] M_icode, W_icode;
input M_cnd;

output reg [63:0] PC_new;

always @(*)
    begin
        if(M_icode==7 && !M_cnd)
        begin
            PC_new <= M_valA;
        end
        else if(W_icode==9)
        begin
            PC_new <= W_valM;
        end
        else
        begin
            PC_new <= F_predPC;
        end
    end

endmodule

module fetch (clk, F_pc, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_stat, F_stat, predPC, instr_valid, imem_err, hlt);

input clk;
input [63:0] F_pc;
input [3:0] F_stat;
output reg [3:0] f_icode, f_ifun, f_rA, f_rB, f_stat;
output reg [63:0] f_valP, predPC;
output reg [0:63] f_valC;
output reg instr_valid, imem_err, hlt;

reg [7:0]  memory[0:1023]; // 1 KB
reg [0:79] instruction; // lsb -> msb... 0th bit is least significant

initial begin 

  // Instruction memory
 hlt = 0;

    memory[0]  = 8'b00010000; // nop instruction 
    memory[1]  = 8'b01100000; // Opq add
    memory[2]  = 8'b00000001; // rA = 0, rB = 1; 

    memory[3]  = 8'b00110000; // irmovq instruction 
    memory[4]  = 8'b11110010; // F, rB = 2;
    memory[5]  = 8'b11111111; // 1st byte of V = 255, rest all bytes will be zero
    memory[6]  = 8'b00000000; // 2nd byte
    memory[7]  = 8'b00000000; // 3rd byte
    memory[8]  = 8'b00000000; // 4th byte
    memory[9]  = 8'b00000000; // 5th byte
    memory[10] = 8'b00000000; // 6th byte
    memory[11] = 8'b00000000; // 7th byte
    memory[12] = 8'b00000000; // 8th byte (This completes irmovq)

    memory[13]  = 8'b00010000; // nop instruction
    memory[14]  = 8'b00010000; // nop instruction
    memory[15]  = 8'b00010000; // nop instruction
    memory[16]  = 8'b00010000; // nop instruction

    memory[17] = 8'b00110000; // irmovq instruction 
    memory[18] = 8'b11110011; // F, rB = 3;
    memory[19] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    memory[20] = 8'b00000000; // 2nd byte
    memory[21] = 8'b00000000; // 3rd byte
    memory[22] = 8'b00000000; // 4th byte
    memory[23] = 8'b00000000; // 5th byte
    memory[24] = 8'b00000000; // 6th byte
    memory[25] = 8'b00000000; // 7th byte
    memory[26] = 8'b00000000; // 8th byte (This completes irmovq)

    memory[27]  = 8'b00010000; // nop instruction
    memory[28]  = 8'b00010000; // nop instruction
    memory[29]  = 8'b00010000; // nop instruction
    memory[30]  = 8'b00010000; // nop instruction

    memory[31] = 8'b00110000; // irmovq instruction 
    memory[32] = 8'b11110100; // F, rB = 4;
    memory[33] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    memory[34] = 8'b00000000; // 2nd byte
    memory[35] = 8'b00000000; // 3rd byte
    memory[36] = 8'b00000000; // 4th byte
    memory[37] = 8'b00000000; // 5th byte
    memory[38] = 8'b00000000; // 6th byte
    memory[39] = 8'b00000000; // 7th byte
    memory[40] = 8'b00000000; // 8th byte (This completes irmovq)

    memory[41]  = 8'b00010000; // nop instruction
    memory[42]  = 8'b00010000; // nop instruction
    memory[43]  = 8'b00010000; // nop instruction
    memory[44]  = 8'b00010000; // nop instruction

    memory[45] = 8'b00100000; // rrmovq 
    memory[46] = 8'b01000101; // rA = 4; rB = 5; 

    memory[47] = 8'b01100000; // Opq add 
    memory[48] = 8'b00110100; // rA = 3 and rB = 4, final value in rB(4) = 10;
    
    memory[49] = 8'b00000000; // halt


  end

always @*
begin
  imem_err=0;
  if (F_pc > 101) begin
   imem_err =1;
  end

  instruction = {
    memory[F_pc],
    memory[F_pc+1],
    memory[F_pc+2],
    memory[F_pc+3],
    memory[F_pc+4],
    memory[F_pc+5],
    memory[F_pc+6],
    memory[F_pc+7],
    memory[F_pc+8],
    memory[F_pc+9]
  };

  f_icode = instruction[0:3];
  f_ifun  = instruction[4:7];
  instr_valid = 1'd0;
  hlt = 64'd0;
  case(f_icode)

    //hlt
    4'h0  : begin
      hlt = 64'd1;
      f_valP= F_pc + 64'd1;
    end

    //nop
    4'h1	: f_valP= F_pc + 64'd1;

    /* cmovXX
      4'd0	: //rrmovq
      4'd1	: //cmovle
      4'd2	: //cmovl
      4'd3	: //cmove
      4'd4	: //cmovne
      4'd5	: //cmovge
      4'd6	: //cmovg */
    4'h2	: begin            
      f_rA = instruction[8:11];
      f_rB = instruction[12:15];
      f_valP =F_pc + 64'd2;
    end
    

    //irmovq
    4'h3	: begin
        f_rA = instruction[8:11];  // F
        f_rB = instruction[12:15]; 
        f_valC = {
          instruction[72:79],
          instruction[64:71],
          instruction[56:63],
          instruction[48:55],
          instruction[40:47],
          instruction[32:39],
          instruction[24:31],
          instruction[16:23]
        };
        f_valP = F_pc + 64'd10;
    end
    
    //rmmovq
    4'h4	: begin
      f_rA = instruction[8:11];
      f_rB = instruction[12:15]; 
      f_valC = {
        instruction[72:79],
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23]
      };
      f_valP = F_pc + 64'd10;
    end

    //mrmovq  
    4'h5	: begin
      f_rA = instruction[8:11];
      f_rB = instruction[12:15]; 
      f_valC = {
        instruction[72:79],
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23]
      };
      f_valP = F_pc + 64'd10;
    end 
    
    /* opq
      4'd0	: //addq
      4'd1	: //subq
      4'd2	: //andq
      4'd3	: //xorq
      end*/
    4'h6	: begin
        f_rA[3:0] = instruction[8:11];
        f_rB[3:0] = instruction[12:15];
        f_valP = F_pc + 64'd2;
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
      f_valC = {
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23],
        instruction[8:15]
      };
      f_valP = F_pc + 64'd9;
    end 

    //call
    4'h8	: begin
      f_valC = {
        instruction[64:71],
        instruction[56:63],
        instruction[48:55],
        instruction[40:47],
        instruction[32:39],
        instruction[24:31],
        instruction[16:23],
        instruction[8:15]
      };
      f_valP = F_pc + 64'd9;
    end 

    4'h9  : f_valP = F_pc + 64'd1;//ret

    //pushq
    4'hA  :  begin            
      f_rA = instruction[8:11];
      f_rB = instruction[12:15];
      f_valP =F_pc + 64'd2;
    end

    //popq
    4'hB  :  begin            
      f_rA = instruction[8:11];
      f_rB = instruction[12:15];
      f_valP =F_pc + 64'd2;
    end
    
    default : instr_valid = 1'd1;
  endcase
  
end

// ***************************************** //
// ***************************************** //
// predicting PC
always@(f_valP or f_valC or f_icode)
    begin
        if(f_icode == 7 || f_icode == 8)
            begin
                predPC = f_valC;
            end
        else
            begin
                predPC = f_valP;
            end
    end

endmodule
