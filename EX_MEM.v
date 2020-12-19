module EX_MEM(clk_i, rst_i, start_i, RegWrite_i, MemReg_i, MemRead_i, MemWrite_i, ALUResult_i, start_o, RegWrite_o, MemReg_o, MemRead_o, MemWrite_o, rs2_data_i, rd_addr_i, rd_addr_o, ALUResult_o, MemData_o);

//Ports
input clk_i;
input rst_i;
input start_i;
input RegWrite_i, MemReg_i, MemRead_i, MemWrite_i;
input [31:0] ALUResult_i, rs2_data_i;
input [4:0] rd_addr_i;

output start_o;
output RegWrite_o, MemReg_o, MemRead_o, MemWrite_o;
output [31:0] ALUResult_o, MemData_o;
output [4:0] rd_addr_o;

//Registers
reg start_o;
reg RegWrite_o, MemReg_o, MemRead_o, MemWrite_o;
reg [31:0] ALUResult_o, MemData_o;
reg [4:0] rd_addr_o;

initial begin
	{RegWrite_o, MemReg_o, MemRead_o, MemWrite_o, rd_addr_o, ALUResult_o, MemData_o} <= 0;
end

always @(posedge clk_i or posedge rst_i) begin
	if(rst_i) begin
		{ RegWrite_o, MemReg_o, MemRead_o, MemWrite_o, rd_addr_o, ALUResult_o, MemData_o } <= 0;
	end
	else begin
		if(start_i == 1) begin
			start_o <= start_i;
			RegWrite_o <= RegWrite_i;
			MemReg_o <= MemReg_i;
			MemRead_o <= MemRead_i;
			MemWrite_o <= MemWrite_i;
			rd_addr_o <= rd_addr_i;
			ALUResult_o <= ALUResult_i;
			MemData_o <= rs2_data_i;
		end
	end
end
endmodule
