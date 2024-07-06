module pc_update(clk, icode, cond, valC, valM, valP, PC_new);

input cond;
input clk;
input [3:0] icode;
input [63:0] valC;
input [63:0] valM;
input [63:0] valP;

output reg [63:0] PC_new;

always@(*)
    begin
        if(icode==4'b0111) // jxx
        begin
            if(cond==1'b1)
                PC_new = valC;
            else
                PC_new = valP;
        end

        else if(icode==4'b1000) // call
        begin
            PC_new = valC;
        end

        else if(icode==4'b1001) // ret
        begin
            PC_new = valM;
        end

        else
        begin
            PC_new = valP;
        end
    end
endmodule
