module ID_zero
(
	data1_i,
	data2_i, 
	zero_o
);

input [31:0] data1_i;
input [31:0] data2_i;
output zero_o;

reg zero;
assign zero_o = zero;

always @* begin
	if(data1_i == data2_i) begin
		zero = 1;		
	end
	else begin
		zero = 0;
	end
end

endmodule