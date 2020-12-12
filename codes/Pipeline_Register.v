module Pipeline_Register
(
    clk_i,
    start_i,
    stall_i,
    flush_i,
    pc_i,
    data_i,
    pc_o,
    data_o
);

input  			clk_i;
input			start_i;
input  [n-1:0]	data_i;
input  			stall_i, flush_i;
input  [ 31:0]	pc_i;
output [n-1:0]	data_o;
output [ 31:0]  pc_o;

reg    [n-1:0]	data_o;
parameter n = 1;

assign pc_o = pc_i;

always @(posedge start_i) begin
   data_o <= 0; 
end

always @(posedge clk_i) begin
	if (stall_i == 1 || flush_i == 1)
		data_o <= 0;
	else
   		data_o <= data_i;

end
endmodule