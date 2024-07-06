module memory(
  clk, icode, valA, valB, valE, valP, valM
);

  input clk;
  input [3:0] icode;
  input [63:0] valA;
  input [63:0] valB;
  input [63:0] valE;
  input [63:0] valP;
  
  output reg [63:0] valM;
  output reg [63:0] dummy;

  reg [63:0] memory[0:1023];

// ****** ValM is output from memory block. Writing it to the register file has not been taken care of yet

always@(*)
  begin

    if(icode==4'b0100) // rmmovq
    begin
      memory[valE]=valA;
    end
    
    if(icode==4'b1010) // pushq
    begin
      memory[valE]=valA;
    end

    if(icode==4'b1000) // call
    begin
      memory[valE]=valP;
    end
  end
  
always@(posedge clk)
  begin
    
    if(icode==4'b0101) // mrmovq
    begin
      valM=memory[valE];
    end

    if(icode==4'b1011) // popq
    begin
      valM=memory[valE];
    end

    if(icode==4'b1001) // ret
    begin
      valM=memory[valA];
    end

    dummy=memory[valE];
  end
endmodule
