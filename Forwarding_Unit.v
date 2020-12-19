module Forwarding_Unit(ID_EX_RS1, ID_EX_RS2, EX_MEM_RegWrite, EX_MEM_Rd, MEM_WB_RegWrite, MEM_WB_Rd, ForwardA, ForwardB);

//Ports
input [4:0] ID_EX_RS1;
input [4:0] ID_EX_RS2;
input EX_MEM_RegWrite;
input [4:0] EX_MEM_Rd;
input MEM_WB_RegWrite;
input [4:0] MEM_WB_Rd;
output [1:0] ForwardA;
output [1:0] ForwardB;

//Registers
reg [1:0] ForwardA;
reg [1:0] ForwardB;

always @(*) begin
	if ((EX_MEM_RegWrite == 1'b1) && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_RS1))
		ForwardA = 2'b10;
	else if ((MEM_WB_RegWrite == 1'b1) && (MEM_WB_Rd != 5'b0) && (MEM_WB_Rd == ID_EX_RS1))
		ForwardA = 2'b01;
	else
		ForwardA = 2'b00;

	if ((EX_MEM_RegWrite == 1'b1) && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_RS2))
		ForwardB = 2'b10;
	else if ((MEM_WB_RegWrite == 1'b1) && (MEM_WB_Rd != 5'b0) && (MEM_WB_Rd == ID_EX_RS2))
		ForwardB = 2'b01;
	else
		ForwardB = 2'b00;
end 
endmodule