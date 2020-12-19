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

//Wires for IF Stage
wire [31:0] PCNext_pre, PCNext, PCCurrent, PCBranch;
wire PCWrite;
wire BranchTaken;
wire [31:0] Instruction_pre;

PC_Adder PC_Adder(
    .data1_in   (PCCurrent),
    .data2_in   (32'd4),
    .data_o     (PCNext)
);

PC_MUX PC_MUX(
    .branchTaken_i (BranchTaken),
    .addrNotTaken_i (PCNext),
    .addrTaken_i (PCBranch),
    .addr_o (PCNext_pre)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (PCNext_pre),
    .pc_o       (PCCurrent)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PCCurrent), 
    .instr_o    (Instruction_pre)
);

//Wires for IF_ID Stage
wire [31:0] IF_ID_PC_o, Instruction;
wire IFStall;
wire start_IF_IDtoID_EX;

IF_ID IF_ID(
    .clk    (clk_i),
    .rst_i  (rst_i),
    .start_i(start_i),
    .start_o(start_IF_IDtoID_EX),
    .PC_i   (PCCurrent),
    .PC_o   (IF_ID_PC_o),
    .IF_stall   (IFStall),
    .IF_flush   (BranchTaken),
    .instruction_i  (Instruction_pre),
    .instruction_o  (Instruction)
);

wire [4:0] RegisterReadAddr1, RegisterReadAddr2;
wire [6:0] Opcode;
//Wires for ID Stage
//Adder
wire [31:0] SignExtensionOut;
//HazarDetectionUnit
wire MemRead_ID_EXtoEX_MEM;
assign RegisterReadAddr1 = Instruction[19:15];
assign RegisterReadAddr2 = Instruction[24:20];
wire [4:0] RD_ID_EXtoEX_MEM;
wire NoOpSignal; //to Control & ID/EX
wire StallSignal;
//Control
assign Opcode = Instruction[6:0];
wire RegWrite_ControltoID_EX;
wire MemtoReg_ControltoID_EX;
wire MemRead_ControltoID_EX;
wire MemWrite_ControltoID_EX;
wire [1:0] ALUOp;
wire ALUSrc;
wire Branch;
//Registers
wire [4:0] RDaddr_MEM_WBtoRegs;
wire [31:0] RDdata_MEM_WBtoRegs;
wire RegWrite_MEM_WBtoRegs;
wire [31:0] RS1data_RegstoID_EX;
wire [31:0] RS2data_RegstoID_EX;
//Sign_Extend
wire [31:0] SignExtensionIn;
assign SignExtensionIn = Instruction;
//ID_branch
wire Zero_ID_zerotoID_branch;

Branch_Adder Branch_Adder(
    .addr_i     (IF_ID_PC_o),
    .imm_i      (SignExtensionOut),
    .addr_o     (PCBranch)
);

HazardDetectionUnit HazardDetectionUnit(
    .MemReadSignal_i    (MemRead_ID_EXtoEX_MEM),
    .RS1_i  		(RegisterReadAddr1),
    .RS2_i  		(RegisterReadAddr2),
    .RD_i   		(RD_ID_EXtoEX_MEM),
    .noOpSignal_o   	(NoOpSignal),
    .stallSignal_o  	(IFStall),
    .PCWriteSignal_o    (PCWrite)
);

Control Control(
    .Op_i       (Opcode),
    .RegWrite_o (RegWrite_ControltoID_EX), 
    .MemReg_o   (MemtoReg_ControltoID_EX), 
    .MemRead_o  (MemRead_ControltoID_EX), 
    .MemWrite_o (MemWrite_ControltoID_EX), 
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .Branch_o (Branch)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (RegisterReadAddr1),
    .RS2addr_i   (RegisterReadAddr2),
    .RDaddr_i   (RDaddr_MEM_WBtoRegs), 
    .RDdata_i   (RDdata_MEM_WBtoRegs),
    .RegWrite_i (RegWrite_MEM_WBtoRegs), 
    .RS1data_o   (RS1data_RegstoID_EX), 
    .RS2data_o   (RS2data_RegstoID_EX) 
);

Sign_Extend Sign_Extend(
    .data_i     (SignExtensionIn),
    .data_o     (SignExtensionOut)
);

ID_branch ID_branch(
    .branchSignal_i     (Branch),
    .zero_i     (Zero_ID_zerotoID_branch),
    .branchTaken_o      (BranchTaken)
);

ID_zero ID_zero(
    .data1_i    (RS1data_RegstoID_EX),
    .data2_i    (RS2data_RegstoID_EX), 
    .zero_o     (Zero_ID_zerotoID_branch)
);

//Wires for ID/EX Stage
wire start_ID_EXtoEX_MEM;
wire [4:0] RS1_IF_IDtoID_EX;
assign RS1_IF_IDtoID_EX = Instruction [19:15];
wire [4:0] RS2_IF_IDtoID_EX;
assign RS2_IF_IDtoID_EX = Instruction [24:20];
wire [4:0] RD_IF_IDtoID_EX;
assign RD_IF_IDtoID_EX = Instruction [11:7];
wire [9:0] Funct_IF_IDtoID_EX;
assign Funct_IF_IDtoID_EX = {Instruction[31:25], Instruction[14:12]};
wire RegWrite_ID_EXtoEX_MEM;
wire MemtoReg_ID_EXtoEX_MEM;
//wire MemRead_ID_EXtoEX_MEM;
wire MemWrite_ID_EXtoEX_MEM;
wire [1:0] ALUOp_ID_EXtoALUControl;
wire ALUSrc_ID_EXtoMUX;
wire [31:0] RS1data_ID_EXtoMUX;
wire [31:0] RS2data_ID_EXtoMUX;
wire [9:0] Funct_ID_EXtoALUControl;
wire [4:0] RS1_ID_EXtoFU;
wire [4:0] RS2_ID_EXtoFU;
wire [31:0] imm_ID_EXtoMUX;

ID_EX ID_EX(
    .clk_i  (clk_i),
    .rst_i  (rst_i),
    .start_i(start_IF_IDtoID_EX),
    //signals
    .RegWrite_i      (RegWrite_ControltoID_EX),
    .MemtoReg_i  (MemtoReg_ControltoID_EX),
    .MemRead_i   (MemRead_ControltoID_EX),
    .MemWrite_i     (MemWrite_ControltoID_EX),
    .ALUOp_i     (ALUOp),
    .ALUSrc_i    (ALUSrc),
    .NoOp_i      (NoOpSignal),
    //register data
    .reg1Data_i  (RS1data_RegstoID_EX),
    .reg2Data_i  (RS2data_RegstoID_EX),
    //regID
    .rs1_i   (RS1_IF_IDtoID_EX),
    .rs2_i   (RS2_IF_IDtoID_EX),
    .rd_i    (RD_IF_IDtoID_EX),
    //others
    .funct_i     (Funct_IF_IDtoID_EX),
    .imm_i   (SignExtensionOut),

    .start_o    (start_ID_EXtoEX_MEM),
    .RegWrite_o  (RegWrite_ID_EXtoEX_MEM),
    .MemtoReg_o  (MemtoReg_ID_EXtoEX_MEM),
    .MemRead_o   (MemRead_ID_EXtoEX_MEM),
    .MemWrite_o  (MemWrite_ID_EXtoEX_MEM),
    .ALUOp_o     (ALUOp_ID_EXtoALUControl),
    .ALUSrc_o    (ALUSrc_ID_EXtoMUX),
    .reg1Data_o  (RS1data_ID_EXtoMUX),
    .reg2Data_o  (RS2data_ID_EXtoMUX),
    .rs1_o   (RS1_ID_EXtoFU),
    .rs2_o   (RS2_ID_EXtoFU),
    .rd_o    (RD_ID_EXtoEX_MEM),
    .funct_o  (Funct_ID_EXtoALUControl),
    .imm_o   (imm_ID_EXtoMUX)
);

// Wires for EX Stage
wire [31:0] ALUResult_EX_MEMtoDM;
wire [31:0] RS1data_MUXtoALU, RS2data_MUXtoALUMUX;
wire [1:0] Forward_signal_A, Forward_signal_B;
wire RegWrite_EX_MEMtoMEM_WB;
wire [4:0] RD_EX_MEMtoMEM_WB;
wire [31:0] RS2data_ALUMUXtoALU;
wire [2:0] ALUControl;
wire [31:0] ALUResult_ALUtoEX_MEM;
wire ZeroSignal;

MUX32_Pre MUX_data1(
    .data1_i    (RS1data_ID_EXtoMUX), 
    .data2_i    (RDdata_MEM_WBtoRegs), 
    .data3_i    (ALUResult_EX_MEMtoDM),
    .forward_select_i   (Forward_signal_A), 
    .data_o     (RS1data_MUXtoALU)
);

MUX32_Pre MUX_data2(
    .data1_i    (RS2data_ID_EXtoMUX), 
    .data2_i    (RDdata_MEM_WBtoRegs), 
    .data3_i    (ALUResult_EX_MEMtoDM),
    .forward_select_i   (Forward_signal_B), 
    .data_o     (RS2data_MUXtoALUMUX)
);

Forwarding_Unit Forwarding_Unit(
    .ID_EX_RS1  (RS1_ID_EXtoFU), 
    .ID_EX_RS2  (RS2_ID_EXtoFU), 
    .EX_MEM_RegWrite    (RegWrite_EX_MEMtoMEM_WB), 
    .EX_MEM_Rd  (RD_EX_MEMtoMEM_WB), 
    .MEM_WB_RegWrite    (RegWrite_MEM_WBtoRegs), 
    .MEM_WB_Rd  (RDaddr_MEM_WBtoRegs), 
    .ForwardA   (Forward_signal_A), 
    .ForwardB   (Forward_signal_B)
);

MUX32 MUX_ALUSrc(
    .data1_i    (RS2data_MUXtoALUMUX),
    .data2_i    (imm_ID_EXtoMUX),
    .select_i   (ALUSrc_ID_EXtoMUX),
    .data_o     (RS2data_ALUMUXtoALU)
);

ALU_Control ALU_Control(
    .funct_i    (Funct_ID_EXtoALUControl),
    .ALUOp_i    (ALUOp_ID_EXtoALUControl),
    .ALUCtrl_o  (ALUControl)
);

ALU ALU(
    .data1_i    (RS1data_MUXtoALU),
    .data2_i    (RS2data_ALUMUXtoALU),
    .ALUCtrl_i  (ALUControl),
    .data_o     (ALUResult_ALUtoEX_MEM),
    .Zero_o     (ZeroSignal)
);

// Wires for EX/MEM Stage
wire start_EX_MEMtoMEM_WB;
wire MemtoReg_EX_MEMtoMEM_WB;
wire MemRead_EX_MEMtoDM;
wire MemWrite_EX_MEMtoDM;
wire [31:0] RS2data_EXMEMtoDM;

EX_MEM EX_MEM (
    .clk_i  (clk_i), 
    .rst_i  (rst_i),
    .start_i(start_ID_EXtoEX_MEM),
    .RegWrite_i     (RegWrite_ID_EXtoEX_MEM), 
    .MemReg_i   (MemtoReg_ID_EXtoEX_MEM), 
    .MemRead_i  (MemRead_ID_EXtoEX_MEM), 
    .MemWrite_i     (MemWrite_ID_EXtoEX_MEM), 
    .ALUResult_i    (ALUResult_ALUtoEX_MEM), 
    .start_o    (start_EX_MEMtoMEM_WB),
    .RegWrite_o     (RegWrite_EX_MEMtoMEM_WB), 
    .MemReg_o   (MemtoReg_EX_MEMtoMEM_WB), 
    .MemRead_o  (MemRead_EX_MEMtoDM), 
    .MemWrite_o     (MemWrite_EX_MEMtoDM), 
    .rs2_data_i (RS2data_MUXtoALUMUX), 
    .rd_addr_i  (RD_ID_EXtoEX_MEM), 
    .rd_addr_o  (RD_EX_MEMtoMEM_WB), 
    .ALUResult_o    (ALUResult_EX_MEMtoDM), 
    .MemData_o  (RS2data_EXMEMtoDM)
);

//Wires for MEM Stage
wire [31:0] ReadData_DMtoMEM_WB;

Data_Memory Data_Memory (
    .clk_i  (clk_i), 
    .addr_i     (ALUResult_EX_MEMtoDM), 
    .MemRead_i  (MemRead_EX_MEMtoDM),
    .MemWrite_i     (MemWrite_EX_MEMtoDM),
    .data_i     (RS2data_EXMEMtoDM),
    .data_o     (ReadData_DMtoMEM_WB)
);

//Wires for MEM_WB Stage
wire	    MemtoReg_MEM_WBtoWBMUX;
wire [31:0] ALUResult_MEM_WBtoWBMux;
wire [31:0] ReadData_MEM_WBtoWBMux;

MEM_WB MEM_WB(
    .clk_i  (clk_i), 
    .rst_i  (rst_i),
    .start_i (start_EX_MEMtoMEM_WB),
    .RegWrite_i     (RegWrite_EX_MEMtoMEM_WB), 
    .MemReg_i   (MemtoReg_EX_MEMtoMEM_WB), 
    .rd_addr_i  (RD_EX_MEMtoMEM_WB), 
    .RegWrite_o     (RegWrite_MEM_WBtoRegs), 
    .MemReg_o   (MemtoReg_MEM_WBtoWBMUX), 
    .data1_i    (ALUResult_EX_MEMtoDM), 
    .data2_i    (ReadData_DMtoMEM_WB), 
    .data1_o    (ALUResult_MEM_WBtoWBMux), 
    .data2_o    (ReadData_MEM_WBtoWBMux), 
    .rd_addr_o  (RDaddr_MEM_WBtoRegs)
);

MUX32 MUX_WB(
    .data1_i    (ALUResult_MEM_WBtoWBMux),
    .data2_i    (ReadData_MEM_WBtoWBMux),
    .select_i   (MemtoReg_MEM_WBtoWBMUX),
    .data_o     (RDdata_MEM_WBtoRegs)
);

endmodule

