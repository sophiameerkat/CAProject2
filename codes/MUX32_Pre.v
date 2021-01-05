module MUX32_Pre(data1_i, data2_i, data3_i, forward_select_i, data_o);

//Ports
input [31:0] data1_i;
input [31:0] data2_i;
input [31:0] data3_i;
input [1:0] forward_select_i;
output [31:0] data_o;

//Registers 
reg [31:0] data_o;

always@(*) begin
	case(forward_select_i)
		2'b00: data_o = data1_i;
		2'b01: data_o = data2_i;
		2'b10: data_o = data3_i;
	endcase
end

endmodule