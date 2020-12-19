//load (stall)

module HazardDetectionUnit
(
	MemReadSignal_i,
	RS1_i,
	RS2_i,
	RD_i,
	noOpSignal_o,
	stallSignal_o, //to IF/ID latch
	PCWriteSignal_o
);

input MemReadSignal_i;
input [4:0] RS1_i;
input [4:0] RS2_i;
input [4:0] RD_i;
output noOpSignal_o;
output stallSignal_o;
output PCWriteSignal_o;

reg noOpSignal_oReg;
reg stallSignal_oReg;
reg PCWriteSignal_oReg;
assign noOpSignal_o = noOpSignal_oReg;
assign stallSignal_o = stallSignal_oReg;
assign PCWriteSignal_o = PCWriteSignal_oReg;

always@(*) begin
	noOpSignal_oReg = 0;
	stallSignal_oReg = 0;
	PCWriteSignal_oReg = 1;
	
	if(MemReadSignal_i && (RD_i != 0) && (RD_i == RS1_i || RD_i == RS2_i)) begin //load, stall
		noOpSignal_oReg <= 1'b1;
		stallSignal_oReg <= 1'b1;
		PCWriteSignal_oReg <= 1'b0;
	end
end

endmodule
