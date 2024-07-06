module decode (clk,icode,rA, rB, valA,valB ,value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14);

input clk;
input [3:0]  icode;
input [3:0]  rA,rB;
output reg [63:0] valA,valB;
reg [3:0]  inp1,inp2;

input [63:0] value0;
input [63:0] value1;
input [63:0] value2;
input [63:0] value3;
input [63:0] value4;
input [63:0] value5;
input [63:0] value6;
input [63:0] value7;
input [63:0] value8;
input [63:0] value9;
input [63:0] value10;
input [63:0] value11;
input [63:0] value12;
input [63:0] value13;
input [63:0] value14;


reg [0:63] list[0:14];


always@* begin

   list[0] = value0;
   list[1] = value1;
   list[2] = value2;
   list[3] = value3;
   list[4] = value4;
   list[5] = value5;
   list[6] = value6;
   list[7] = value7;
   list[8] = value8;
   list[9] = value9;
   list[10] = value10;
   list[11] = value11;
   list[12] = value12;
   list[13] = value13;
   list[14] = value14;

case(icode)
   
   4'h2  : inp1 = rA;

   4'h4  : begin                      
      inp1 = rA;
      inp2 = rB;
   end

   4'h5  : inp2 = rB;

   4'h6  :  begin                      
      inp1 = rA;
      inp2 = rB;
   end

   4'h8  :   begin  
      inp2 = 4'd4;
   end 

   4'h9  :  begin  
      inp1 = 4'd4;  
      inp2 = 4'd4;
   end 

   4'hA  :  begin  
      inp1 = rA;
      inp2 = 4'd4;
   end 
      
   4'hB  :  begin
      inp1 = 4'd4; 
      inp2 = 4'd4; 
   end 
endcase

valA = list[inp1];
valB = list[inp2];
end

endmodule

//temp reg_file to be moved to wrapper
