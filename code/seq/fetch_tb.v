module fetch_tb();

reg clk;
reg  [63:0]  PC;
wire [3:0]  icode, ifun;
wire [3:0]  rA,rB;
wire [63:0] valP;
wire [0:63] valC;
wire instr_valid, imm_err, hlt;


fetch test(clk,PC, icode, ifun, rA, rB, valC ,valP, instr_valid, imm_err, hlt);

initial 
    begin
        $dumpfile("fetch_tb.vcd");
        $dumpvars(0,fetch_tb);
      PC =10;
    end
always @ *
   $monitor("time=%0d \n PC=%0d, icode=%0d, ifun=%0d, rA=%0d, rB=%0d \n valC=%0d ,valP=%0d, instr_valid=%0d, imm_err=%0d, hlt=%0d\n", $time, PC, icode, ifun, rA, rB, valC ,valP, instr_valid, imm_err, hlt); 
endmodule