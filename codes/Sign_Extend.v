module Sign_Extend(data_i, data_o);

//Ports
input [31:0] data_i; //it is now the whole instruction
//input [9:0] op_i; //funct3 + opcode
output [31:0] data_o;
wire [9:0] op_i = {data_i[14:12], data_i[6:0]};
reg [31:0] data_o;
//addi [31:20], srai [24:20], lw [31:20], sw [31:25] [11:7], beq [31] [7] [30:25] [11:8]
always@(*) begin
	case(op_i)
		10'b0000010011 : //addi 
		begin
			data_o = { {20{data_i[31]}}, data_i[31:20] };
		end
		10'b1010010011 : //srai
		begin
			data_o = { {27{data_i[24]}}, data_i[24:20] };
		end
		10'b0100000011 : //lw
		begin
			data_o = { {20{data_i[31]}}, data_i[31:20] };
		end
		10'b0100100011 : //sw
		begin
			data_o = { {20{data_i[31]}}, data_i[31:25], data_i[11:7] };
		end
		10'b0001100011 : //beq
		begin
			data_o = { {20{data_i[31]}}, data_i[31], data_i[7], data_i[30:25], data_i[11:8] };
		end
	endcase
end
endmodule