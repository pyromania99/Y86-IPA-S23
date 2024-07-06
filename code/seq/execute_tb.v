module execute_tb();

reg clk;
reg [3:0]  icode,ifun;
reg [63:0] valA,valB,valC;

wire [63:0] valE;
wire cnd;


execute test(clk,icode,ifun,valA,valB,valC,valE,cnd);

initial 
    begin
        $dumpfile("execute_tb.vcd");
        $dumpvars(0,execute_tb);
      icode = 4'h6;
      ifun =  4'h1;

      valA = 64'h1;
      valB = 64'h2;
      valC = 64'h3;

    end
always @ *
   $monitor("time=%0d \n icode=%0d, ifun=%0d, valA=%0d valB=%0d, valC=%0d, \n valE=%0d, cnd=%0d, ", $time, icode,ifun,valA,valB,valC,valE,cnd); 

endmodule