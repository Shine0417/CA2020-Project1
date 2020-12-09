module Pipeline_Register
(
    clk_i,
    start_i,
    data_i,
    data_o,
);

input clk_i;
input start_i;
input [n-1:0] data_i;
output [n-1:0] data_o;

reg [n-1:0] data_o;
parameter n = 1;
always @(posedge start_i) begin
   data_o <= 0; 
end
always @(posedge clk_i) begin
   data_o <= data_i; 
end
endmodule