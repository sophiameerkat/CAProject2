module PC_Adder(data1_in, data2_in, data_o);

//Ports
input [31:0] data1_in;
input [31:0] data2_in;
output [31:0] data_o;

//Registers
reg [31:0] data_o;

always@(data1_in) begin
	data_o = data1_in + data2_in;
end

endmodule
