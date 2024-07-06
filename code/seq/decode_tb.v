module decode_tb();

reg clk;
reg [3:0]  icode;
reg [3:0]  rA,rB;
wire [63:0] valA,valB;
reg [63:0] value0;
reg [63:0] value1;
reg [63:0] value2;
reg [63:0] value3;
reg [63:0] value4;
reg [63:0] value5;
reg [63:0] value6;
reg [63:0] value7;
reg [63:0] value8;
reg [63:0] value9;
reg [63:0] value10;
reg [63:0] value11;
reg [63:0] value12;
reg [63:0] value13;
reg [63:0] value14;

decode test(clk,icode,rA, rB, valA,valB,value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14);
integer i;

initial 
    begin
        $dumpfile("decode_tb.vcd");
        $dumpvars(0,decode_tb);
      icode = 4'hA;
      rA = 4'h5;
      rB = 4'hB;
      value0 = 64'h0;
      value1 = 64'h1;
      value2 = 64'h2;
      value3 = 64'h3;
      value4 = 64'h4;
      value5 = 64'h5;
      value6 = 64'h6;
      value7 = 64'h7;
      value8 = 64'h8;
      value9 = 64'h9;
      value10 = 64'h10;
      value11 = 64'h11;
      value12 = 64'h12;
      value13 = 64'h13;
      value14 = 64'h14;
    end
always @ *
   $monitor("time=%0d \n icode=%0d, rA=%0d, rB=%0d valA=%0d, valB=%0d, \n ", $time, icode,rA, rB, valA,valB); 

endmodule