module ID_branch
(
	branchSignal_i,
	zero_i,
	branchTaken_o
);

input branchSignal_i;
input zero_i;
output branchTaken_o;

assign branchTaken_o = branchSignal_i & zero_i;

endmodule