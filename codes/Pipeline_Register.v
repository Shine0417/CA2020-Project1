module Pipeline_Register
(
    clk_i,
    data_i,
    data_o,
);

input clk_i;
input [n-1:0] data_i;
output [n-1:0] data_o;

reg [n-1:0] data_o;
parameter n = 1;

always @(*) begin
   data_o = data_i; 
end
endmodule