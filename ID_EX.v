module ID_EX
(
	clk_i,
	rst_i,
	start_i,
	//signals
	RegWrite_i,
	MemtoReg_i,
	MemRead_i,
	MemWrite_i,
	ALUOp_i,
	ALUSrc_i,
	NoOp_i,
	//register data
	reg1Data_i,
	reg2Data_i,
	//regID
	rs1_i,
	rs2_i,
	rd_i,
	//others
	funct_i,
	imm_i,

	start_o,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	ALUOp_o,
	ALUSrc_o,
	reg1Data_o,
	reg2Data_o,
	rs1_o,
	rs2_o,
	rd_o,
	funct_o,
	imm_o
);

input clk_i;
input rst_i;
input start_i;
input RegWrite_i;
input MemtoReg_i;
input MemRead_i;
input MemWrite_i;
input [1:0] ALUOp_i;
input ALUSrc_i;
input NoOp_i;
input [31:0] reg1Data_i;
input [31:0] reg2Data_i;
input [4:0] rs1_i;
input [4:0] rs2_i;
input [4:0] rd_i;
input [9:0] funct_i;
input [31:0] imm_i;
output start_o;
output RegWrite_o;
output MemtoReg_o;
output MemRead_o;
output MemWrite_o;
output [1:0] ALUOp_o;
output ALUSrc_o;
output [31:0] reg1Data_o;
output [31:0] reg2Data_o;
output [4:0] rs1_o;
output [4:0] rs2_o;
output [4:0] rd_o;
output [9:0] funct_o;
output [31:0] imm_o;

//registers
reg start_o;
reg RegWrite_o;
reg MemtoReg_o;
reg MemRead_o;
reg MemWrite_o;
reg [1:0] ALUOp_o;
reg ALUSrc_o;
reg [31:0] reg1Data_o;
reg [31:0] reg2Data_o;
reg [4:0] rs1_o;
reg [4:0] rs2_o;
reg [4:0] rd_o;
reg [9:0] funct_o;
reg [31:0] imm_o;

always @(posedge clk_i or posedge rst_i) begin
	if(rst_i) begin
		{ start_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUOp_o, ALUSrc_o, reg1Data_o, reg2Data_o, rs1_o, rs2_o, rd_o, funct_o, imm_o } <= 0;
	end
	else begin
		if(start_i == 1) begin
			start_o = start_i;
			if(NoOp_i == 1) begin
				RegWrite_o <= 0;
				MemtoReg_o <= 0;
				MemRead_o <= 0;
				MemWrite_o <= 0;
				ALUOp_o <= 0;
				ALUSrc_o <= 0;
			end

			else begin
				RegWrite_o <= RegWrite_i;
				MemtoReg_o <= MemtoReg_i;
				MemRead_o <= MemRead_i;
				MemWrite_o <= MemWrite_i;
				ALUOp_o <= ALUOp_i;
				ALUSrc_o <= ALUSrc_i;
			end	

			reg1Data_o <= reg1Data_i;
			reg2Data_o <= reg2Data_i;
			rs1_o <= rs1_i;
			rs2_o <= rs2_i;
			rd_o <= rd_i;
			funct_o <= funct_i;
			imm_o <= imm_i;		
		end
	end
end

endmodule
