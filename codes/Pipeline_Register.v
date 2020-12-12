module Pipeline_Register
(
    clk_i,
<<<<<<< HEAD
    stall_i,
    flush_i,
    pc_i, 
=======
    start_i,
>>>>>>> main
    data_i,
    pc_o,
    data_o
);

<<<<<<< HEAD
input  			clk_i;
input  [n-1:0]	data_i;
input  			stall_i, flush_i;
input  [ 31:0]	pc_i;
output [n-1:0]	data_o;
output [ 31:0]  pc_o;
=======
input clk_i;
input start_i;
input [n-1:0] data_i;
output [n-1:0] data_o;
>>>>>>> main

reg    [n-1:0]	data_o;
parameter n = 1;
<<<<<<< HEAD

assign pc_o = pc_i;

=======
always @(posedge start_i) begin
   data_o <= 0; 
end
>>>>>>> main
always @(posedge clk_i) begin
	if (stall_i == 1 || flush_i == 1)
		data_o <= 0;
	else
   		data_o <= data_i;

end
endmodule