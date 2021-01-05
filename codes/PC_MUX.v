module PC_MUX
(
	branchTaken_i,
	addrNotTaken_i,
	addrTaken_i,
	addr_o
);

input branchTaken_i;
input [31:0] addrNotTaken_i;
input [31:0] addrTaken_i;
output [31:0] addr_o;

reg [31:0] addr_oReg;
assign addr_o = addr_oReg;

//always @(addrTaken_i and addrNotTaken_i) begin
always @* begin

	if(branchTaken_i) begin
		addr_oReg = addrTaken_i;
	end
	else begin
		addr_oReg = addrNotTaken_i;
	end
end

endmodule
