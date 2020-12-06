module Imm_Gen(
    data_i     ,
    data_o     
);

input   [31:0]  data_i;
output  [31:0]  data_o;

reg     [31:0]  data_o;

always @(*) begin
    if(data_i[6:0] == 7'b0100011) // sw
    begin
        data_o = {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
    end
    else // others
    begin
        data_o = {{20{data_i[31]}},data_i[31:20]};
    end
end

endmodule