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
wire [31:0] ins;

wire [1:0] ALUOp;
wire ALUSrc, RegWrite;
wire [31:0] sign_extend_wire;
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] mux_wire;
wire [31:0] ALU_result;
wire [2:0] ALU_control_wire;
wire Zero;

// additional
wire MemtoReg;
wire MemRead;
wire MemWrite;
wire [31:0] data_memory_output;
wire [31:0] write_register;
wire Branch;

Control Control(
    .Op_i           (ins[6:0]),
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
    .RS1addr_i   (ins[19:15]),
    .RS2addr_i   (ins[24:20]),
    .RDaddr_i   (ins[11:7]),
    .RDdata_i   (write_register),
    .RegWrite_i (RegWrite), 
    .RS1data_o   (read_data1), 
    .RS2data_o   (read_data2) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (read_data2),
    .data2_i    (sign_extend_wire),
    .select_i   (ALUSrc),
    .data_o     (mux_wire)
);

MUX32 REG_WRISrc(
    .data1_i    (ALU_result),
    .data2_i    (data_memory_output),
    .select_i   (MemtoReg),
    .data_o     (write_register)
);

Sign_Extend Sign_Extend(
    .data_i     (ins[31:20]),
    .data_o     (sign_extend_wire)
);

  

ALU ALU(
    .data1_i    (read_data1),
    .data2_i    (mux_wire),
    .ALUCtrl_i  (ALU_control_wire),
    .data_o     (ALU_result),
    .Zero_o     (Zero)
);


ALU_Control ALU_Control(
    .funct_i    ({ins[31:25], ins[14:12]}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALU_control_wire)
);

Data_Memory Data_Memory(
    .clk_i      (clk_i), 
    .addr_i     (ALU_result), 
    .MemRead_i  (MemRead),
    .MemWrite_i (MemWrite),
    .data_i     (read_data2),
    .data_o     (data_memory_output)
);

Hazard_Detection Hazard_Detection(//todo
    .Stall_o    ()
);

endmodule