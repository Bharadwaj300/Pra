`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 22:13:04
// Design Name: 
// Module Name: data_splitter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module data_splitter(
input clk,
input rst_n,
input in_valid,
input [31:0] in_data,
input [1:0] src_size,
input [1:0] dst_size,
output reg out_valid,
output reg [31:0] out_data
);

reg [31:0] buffer;
reg [2:0] count, max_parts;
reg active;
reg in_valid_d;

/* MAX PARTS */
always @(*) begin
    if(src_size==3 && dst_size==1) max_parts=4;
    else if(src_size==3 && dst_size==2) max_parts=2;
    else if(src_size==2 && dst_size==1) max_parts=2;
    else max_parts=1;
end

/* EDGE DETECT */
wire new_data = in_valid & ~in_valid_d;

always @(posedge clk or negedge rst_n)
if(!rst_n) begin
    count<=0; out_valid<=0; active<=0; in_valid_d<=0;
end
else begin
    in_valid_d <= in_valid;
    out_valid <= 0;

    /* LOAD ONLY ON NEW DATA */
    if(new_data) begin
        buffer <= in_data;
        count  <= 0;
        active <= 1;
    end
    else if(active) begin
        out_valid <= 1;
        out_data  <= buffer >> (count*8);
        count <= count + 1;

        if(count == max_parts-1)
            active <= 0;
    end
end

endmodule
