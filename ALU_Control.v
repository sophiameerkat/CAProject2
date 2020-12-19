module ALU_Control(funct_i, ALUOp_i, ALUCtrl_o);

//Ports
input [9:0] funct_i;
input [1:0] ALUOp_i;
output [2:0] ALUCtrl_o;

//Registers
reg [2:0] ALUCtrl_o;

always @(funct_i or ALUOp_i) begin
	if (ALUOp_i == 2'b00)
		if (funct_i == 10'b0100000101)
			ALUCtrl_o = 3'b100; //srai
		else
			ALUCtrl_o = 3'b101; //addi
	else
		case(funct_i)
			10'b0000000111: ALUCtrl_o = 3'b000; //and
			10'b0000000100: ALUCtrl_o = 3'b001; //xor
			10'b0000000001: ALUCtrl_o = 3'b011; //sll
			10'b0000000000: ALUCtrl_o = 3'b010; //add
			10'b0100000000: ALUCtrl_o = 3'b110; //sub
			10'b0000001000: ALUCtrl_o = 3'b111; //mul
	endcase
end
endmodule
