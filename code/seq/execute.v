`include "alu_64.v"

module execute(clk,icode,ifun,valA,valB,valC,valE,cnd);

input clk;
input [3:0]  icode,ifun;
input [63:0] valA,valB,valC;

output reg [63:0] valE;
output reg cnd;

reg [1:0]func;
reg [63:0] inp1,inp2;

wire [63:0] out1;
wire of ;

reg [2:0]CC;  // as zf,sf,of

alu_64 inst1(func,inp1,inp2,out1,of);

always@* begin
   cnd =0;
case(icode)

   4'h2  :begin
      func =0;
      inp1 =valA;
      inp2 =0;
      case(ifun)
         4'h0: cnd =1;
         4'h1: cnd = ((CC[1]^CC[2]) || CC[0]);
         4'h2: cnd = ((CC[1]^CC[2]));
         4'h3: cnd = CC[0];
         4'h4: begin
            if(!CC[0])
                 cnd = 1;
         end
         4'h5:begin
            if(!(CC[1]^CC[2]))
            cnd =1;
         end
         4'h6:begin
           if(!((CC[1]^CC[2]) || CC[0]))
           cnd =1;
         end
      endcase
   end

   4'h3  :begin
      func =0;
      inp1 =valC;
      inp2 =0;
   end

   4'h4  :begin 
      func =0;
      inp1 =valB;
      inp2 =valC;
   end

   4'h5  :begin  
      func =0;
      inp1 =valC;
      inp2 =valB;
   end

   4'h6  :begin
      func =ifun[1:0];
      inp1 =valA;
      inp2 =valB;

      //zf,sf,of respectively
      CC[0] = (out1==1'b0);
      CC[1] = (out1<1'b0);
      CC[2] = (valA<1'b0==valB<1'b0)&&(out1<1'b0!=valA<1'b0);
   end

   4'h7  :begin
      case(ifun)
         4'h0: cnd =1;
         4'h1: cnd = ((CC[1]^CC[2]) || CC[0]);
         4'h2: cnd = ((CC[1]^CC[2]));
         4'h3: cnd = CC[0];
         4'h4: begin
            if(!CC[0])
               cnd = 1;
         end
         4'h5:begin
            if(!(CC[1]^CC[2]))
            cnd =1;
         end
         4'h6:begin
           if(!((CC[1]^CC[2]) || CC[0]))
           cnd =1;
         end
      endcase
   end

   4'h8  :begin
      func =1;
      inp1 =64'h8;
      inp2 =valB;
   end 

   4'h9  :begin 
      func =0;
      inp1 =64'h8;
      inp2 =valB;
   end 

   4'hA  :begin
      func =1;
      inp1 =64'h8;
      inp2 =valB;
   end 
      
   4'hB  :begin
      func =0;
      inp1 =64'h8;
      inp2 =valB;
   end 
endcase

valE =out1; 

end
endmodule