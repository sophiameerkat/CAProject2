module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];
reg      last[0:15];
reg      isFilled[0:15][0:1];

integer            i, j;

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
                isFilled[i][j] <= 1'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if (isFilled[addr_i][0] == 0) begin //block 0 is available to use
            data[addr_i][0] <= data_i;
            tag[addr_i][0] <= tag_i;
            last[addr_i] <= 0;
            isFilled[addr_i][0] <= 1;
        end
        else if (isFilled[addr_i][1] == 0) begin //block 1 is available to use
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= tag_i;
            last[addr_i] <= 1;
            isFilled[addr_i][1] <= 1;
        end
        else begin //block 0 and 1 are not available to use => LRU
            if (last[addr_i] == 1) begin
                data[addr_i][0] <= data_i;
                tag[addr_i][0] <= tag_i;
                last[addr_i] <= 0;
            end
            else begin
                data[addr_i][1] <= data_i;
                tag[addr_i][1] <= tag_i;
                last[addr_i] <= 1;
            end
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?

assign data_o = (enable_i == 0) ? 256'b0 : 
        ((tag_i[24] == 1 && tag[addr_i][0][24] == 1 && tag_i[22:0] == tag[addr_i][0]) ? data[addr_i][0] : // valid bit of the input == 1 and tag of input == tag address for block 0
            ((tag_i[24] == 1 && tag[addr_i][1][24] == 1 && tag_i[22:0] == tag[addr_i][1]) ? data[addr_i][1] : 256'b0)); // valid bit of the input == 1 and tag of input == tag address for block 1
assign tag_o = (enable_i == 0) ? 25'b0 :
        ((tag_i[24] == 1 && tag[addr_i][0][24] == 1 && tag_i[22:0] == tag[addr_i][0]) ? tag[addr_i][0] : // valid bit of the input == 1 and tag of input == tag address for block 0
            ((tag_i[24] == 1 && tag[addr_i][1][24] == 1 && tag_i[22:0] == tag[addr_i][1]) ? tag[addr_i][1] : 25'b0)); // valid bit of the input == 1 and tag of input == tag address for block 1
assign hit_o = (enable_i == 0) ? 1'b0 :
        (((tag_i[24] == 1 && tag[addr_i][0][24] == 1 && tag_i[22:0] == tag[addr_i][0]) || (tag_i[24] == 1 && tag[addr_i][1][24] == 1 && tag_i[22:0] == tag[addr_i][1])) ? 1'b1 : 1'b0);

endmodule
