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
    hit_o,
    debug_data0_o,
    debug_data1_o,
    debug_last_o,
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

integer            i, j;

wire block_hit[0:1];


//debug
output [255:0] debug_data0_o;
output [255:0] debug_data1_o;
output debug_last_o;
assign debug_data0_o = data[0][0];
assign debug_data1_o = data[0][1];
assign debug_last_o = last[addr_i];


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if(hit_o) begin
            if(block_hit[0]) begin
                data[addr_i][0] <= data_i;
                tag[addr_i][0][24:23] <= 2'b11;
                last[addr_i] <= 1'b0;
            end
            else begin
                data[addr_i][1] <= data_i;
                tag[addr_i][1][24:23] <= 2'b11;
                last[addr_i] <= 1'b1;
            end
        end
        else begin 
            if (last[addr_i] == 1'b1) begin
                data[addr_i][0] <= data_i;
                tag[addr_i][0][22:0] <= tag_i[22:0];
                tag[addr_i][0][24:23] <= 2'b11;
                last[addr_i] <= 1'b0;
            end
            else begin
                data[addr_i][1] <= data_i;
                tag[addr_i][1][22:0] <= tag_i[22:0];
                tag[addr_i][1][24:23] <= 2'b11;
                last[addr_i] <= 1'b1;
            end
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?

assign block_hit[0] = ((tag[addr_i][0][24] == 1) && (tag_i[22:0] == tag[addr_i][0][22:0])) ? 1'b1 : 1'b0;
assign block_hit[1] = ((tag[addr_i][1][24] == 1) && (tag_i[22:0] == tag[addr_i][1][22:0])) ? 1'b1 : 1'b0;

assign data_o = (enable_i == 0) ? 256'b0 : 
        (block_hit[0] == 1) ? data[addr_i][0] : 
        (block_hit[1] == 1) ? data[addr_i][1] : data[addr_i][last[addr_i]];
/*
assign tag_o = (enable_i == 0) ? 25'b0 :
        (block_hit[0] == 1) ? tag[addr_i][0] : 
        (block_hit[1] == 1) ? tag[addr_i][1] : tag[addr_i][last[addr_i]];
*/
assign tag_o = (enable_i == 0) ? 25'b0 :
        (write_i && hit_o) ? {2'b10, tag_i[22:0]} :
        (block_hit[0] == 1) ? tag[addr_i][0] : 
        (block_hit[1] == 1) ? tag[addr_i][1] : tag[addr_i][last[addr_i]];

//assign hit = sram_valid & (cpu_tag == sram_tag);

assign hit_o = (enable_i == 0) ? 1'b0 :
        ((block_hit[0] == 1) || (block_hit[1] == 1)) ? 1'b1 : 1'b0;

endmodule