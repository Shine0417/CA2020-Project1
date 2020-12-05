module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] address;
wire [31:0] new_address;
wire [31:0] ins, ins_ID, ins_EX, ins_MEM, ins_WB;

wire [1:0] ALUOp, ALUOp_EX;
wire RegWrite, RegWrite_EX, Registers_MEM, RegWrite_WB;
wire ALUSrc, ALUSrc_EX;
wire [31:0] sign_extend_wire, sign_extend_wire_EX;
wire [31:0] read_data1, read_data1_EX;
wire [31:0] read_data2, read_data2_EX, read_data2_MEM;
wire [31:0] mux_wire;
wire [31:0] ALU_result, ALU_result_MEM, ALU_result_WB;
wire [2:0] ALU_control_wire;
wire Zero;

// additional
wire MemtoReg, MemtoReg_EX, MemtoReg_MEM;
wire MemRead, MemRead_EX, MemRead_MEM;
wire MemWrite, MemWrite_EX, MemWrite_MEM;
wire [31:0] data_memory_output, data_memory_output_WB;
wire [31:0] write_register;
wire Branch;

Pipeline_Register #(.n(32)) IF_ID (
    .clk_i     (clk_i),
    .data_i     (ins),
    .data_o     (ins_ID)
);

Pipeline_Register #(.n(118)) ID_EX (
    .clk_i     (clk_i),
    .data_i     ({RegWrite, MemtoReg, MemRead, MemWrite, ALUOp, ALUSrc, read_data1, read_data2, sign_extend_wire, {ins_ID[31:25], ins_ID[14:12]}, ins_ID[11:7]}),
    .data_o     ({RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, ALUOp_EX, ALUSrc_EX, read_data1_EX, read_data2_EX, sign_extend_wire_EX, {ins_EX[31:25], ins_EX[14:12]}, ins_EX[11:7]})
);
Pipeline_Register #(.n(73)) EX_MEM (
    .clk_i     (clk_i),
    .data_i     ({RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, ALU_result, read_data2_EX, ins_EX[11:7]}),
    .data_o     ({RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM, ALU_result_MEM, read_data2_MEM, ins_MEM[11:7]})
);
Pipeline_Register #(.n(71)) MEM_WB (
    .clk_i      (clk_i),
    .data_i     ({RegWrite_MEM, MemtoReg_MEM, ALU_result_MEM, data_memory_output, ins_MEM[11:7]}),
    .data_o     ({RegWrite_WB, MemtoReg_WB, ALU_result_WB, data_memory_output_WB, ins_WB[11:7]})
);


Control Control(
    .Op_i           (ins_ID[6:0]),
    .RegWrite_o     (RegWrite),
    .MemtoReg_o       (MemtoReg),
    .MemRead_o        (MemRead),
    .MemWrite_o  (MemWrite),
    .ALUOp_o        (ALUOp),
    .ALUSrc_o       (ALUSrc),
    .Branch_o       (Branch)
);


Adder Add_PC(
    .data1_in   (address),
    .data2_in   (32'b100),
    .data_o     (new_address)
);


PC PC(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .start_i        (start_i),
    .PCWrite_i      (1'b1),
    .pc_i           (new_address),
    .pc_o           (address)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (address), 
    .instr_o    (ins)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (ins_ID[19:15]),
    .RS2addr_i   (ins_ID[24:20]),
    .RDaddr_i   (ins_WB[11:7]),
    .RDdata_i   (write_register),
    .RegWrite_i (RegWrite_WB), 
    .RS1data_o   (read_data1), 
    .RS2data_o   (read_data2) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (read_data2_EX),
    .data2_i    (sign_extend_wire_EX),
    .select_i   (ALUSrc_EX),
    .data_o     (mux_wire)
);

MUX32 REG_WRISrc(
    .data1_i    (ALU_result_WB),
    .data2_i    (data_memory_output_WB),
    .select_i   (MemtoReg_WB),
    .data_o     (write_register)
);

Sign_Extend Sign_Extend(
    .data_i     (ins_ID[31:20]),
    .data_o     (sign_extend_wire)
);

  

ALU ALU(
    .data1_i    (read_data1_EX),
    .data2_i    (mux_wire),
    .ALUCtrl_i  (ALU_control_wire),
    .data_o     (ALU_result),
    .Zero_o     (Zero)
);


ALU_Control ALU_Control(
    .funct_i    ({ins_EX[31:25], ins_EX[14:12]}),
    .ALUOp_i    (ALUOp_EX),
    .ALUCtrl_o  (ALU_control_wire)
);

Data_Memory Data_Memory(
    .clk_i      (clk_i), 
    .addr_i     (ALU_result_MEM), 
    .MemRead_i  (MemRead_MEM),
    .MemWrite_i (MemWrite_MEM),
    .data_i     (read_data2_MEM),
    .data_o     (data_memory_output)
);

Hazard_Detection Hazard_Detection(//todo
    .Stall_o    ()
);

endmodule