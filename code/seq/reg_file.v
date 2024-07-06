//temp reg_file to be moved to wrapper
module reg_file(flag,inp1,out1,Wval);

input flag; //one bit 0 to read ,1 to write
input [3:0] inp1;  //reg index
input [63:0] Wval;
output reg [63:0] out1;
reg [0:63] list[0:14];

initial begin
   list[0]=64'd0;
   list[1]=64'd1;
   list[2]=64'd2;
   list[3]=64'd3;
   list[4]=64'd4;
   list[5]=64'd5;
   list[6]=64'd6;
   list[7]=64'd7;
   list[8]=64'd8;
   list[9]=64'd9;
   list[10]=64'd10;
   list[11]=64'd11;
   list[12]=64'd12;
   list[13]=64'd13;
   list[14]=64'd14;
end

always @ (inp1) begin

if(!flag)
begin
   out1 = list[inp1];
end

else begin
   list[inp1] = Wval;
end
end
endmodule