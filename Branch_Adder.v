module Branch_Adder
(
	addr_i,
	imm_i,
	addr_o
);

input [31:0] addr_i;
input [31:0] imm_i;
output [31:0] addr_o;

reg [31:0] addr_o;

always@* begin
	addr_o = addr_i + (imm_i << 1);
end

endmodule
