module Control
(
    Op_i       ,
    RegWrite_o ,
    MemtoReg_o   ,
    MemRead_o    ,
    MemWrite_o   ,
    ALUOp_o    ,
    ALUSrc_o   ,
    Branch_o   
);

// Interface
input   [6:0]      Op_i;
output             RegWrite_o;
output             MemtoReg_o;
output             MemRead_o;
output             MemWrite_o;
output  [1:0]      ALUOp_o;
output             ALUSrc_o;
output             Branch_o;

reg                RegWrite_o;
reg                MemtoReg_o;
reg                MemRead_o;
reg                MemWrite_o;
reg     [1:0]      ALUOp_o;
reg                ALUSrc_o;
reg                Branch_o;

// Control
always @(*) begin
    //default
    MemtoReg_o = 0;
    MemRead_o = 0;
    MemWrite_o = 0;
    Branch_o = 0;
    RegWrite_o = 1;

    if(Op_i == 7'b0110011) //R-type
    begin
        ALUOp_o = 2'b10;
        ALUSrc_o = 0;
    end
    else if(Op_i == 7'b0010011)//addi and srai
    begin
        ALUOp_o = 2'b11;
        ALUSrc_o = 1;
    end
    else if(Op_i == 7'b0000011)// lw
    begin
        ALUOp_o = 2'b00;
        ALUSrc_o = 1;
        MemtoReg_o = 1;
        MemRead_o = 1;
    end
    else if(Op_i == 7'b0100011)// sw
    begin
        ALUOp_o = 2'b00;
        ALUSrc_o = 1;
        MemtoReg_o = 0;// dont care
        MemWrite_o = 1;
        RegWrite_o = 0;
    end
    // else if(Op_i == 7'0000011)// beq
    // begin
    //     ALU
    // end
    else
    begin
        ALUOp_o = 2;
        ALUSrc_o = 0;
    end
    //additional
    
end

endmodule
