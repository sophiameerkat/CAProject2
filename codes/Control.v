module Control(Op_i, RegWrite_o, MemReg_o, MemRead_o, MemWrite_o, ALUOp_o, ALUSrc_o, Branch_o);

//Ports
input [6:0] Op_i;
output RegWrite_o, MemReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
output [1:0] ALUOp_o;

//Regsiters
reg [1:0] ALUOp_o;
reg RegWrite_o, MemReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;

always @(*) begin
	case(Op_i)
		7'b0000000: //NoOp
			begin
			RegWrite_o = 1'b0;
			MemReg_o = 1'b0;
			MemRead_o = 1'b0;
			MemWrite_o = 1'b0;
			ALUOp_o = 2'b00;
			ALUSrc_o = 1'b0;
			Branch_o = 1'b0;
			end
		7'b0110011: //R type
			begin
			RegWrite_o = 1'b1;
			MemReg_o = 1'b0;
			MemRead_o = 1'b0;
			MemWrite_o = 1'b0;
			ALUOp_o = 2'b10;
			ALUSrc_o = 1'b0;
			Branch_o = 1'b0;
			end
		7'b0010011: // I type
			begin
			RegWrite_o = 1'b1;
			MemReg_o = 1'b0;
			MemRead_o = 1'b0;
			MemWrite_o = 1'b0;
			ALUOp_o = 2'b00;
			ALUSrc_o = 1'b1;
			Branch_o = 1'b0;
			end
		7'b0000011: //load
			begin
			RegWrite_o = 1'b1;
			MemReg_o = 1'b1;
			MemRead_o = 1'b1;
			MemWrite_o = 1'b0;
			ALUOp_o = 2'b00;
			ALUSrc_o = 1'b1;
			Branch_o = 1'b0;
			end
		7'b0100011: //store
			begin
			RegWrite_o = 1'b0;
			MemReg_o = 1'b0;
			MemRead_o = 1'b0;
			MemWrite_o = 1'b1;
			ALUOp_o = 2'b00;
			ALUSrc_o = 1'b1;
			Branch_o = 1'b0;
			end
		7'b1100011: //beq
			begin
			RegWrite_o = 1'b0;
			MemReg_o = 1'b0;
			MemRead_o = 1'b0;
			MemWrite_o = 1'b0;
			ALUOp_o = 2'b01;
			ALUSrc_o = 1'b0;
			Branch_o = 1'b1;
			end
	endcase
end
endmodule
