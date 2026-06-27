`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 22:12:04
// Design Name: 
// Module Name: data_combiner
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





module data_combiner(
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
reg [2:0] count, required;
reg in_valid_d;

/* REQUIRED COUNT */
always @(*) begin
    if(src_size==1 && dst_size==2) required=2;
    else if(src_size==1 && dst_size==3) required=4;
    else if(src_size==2 && dst_size==3) required=2;
    else required=1;
end

/* EDGE DETECT */
wire new_data = in_valid & ~in_valid_d;

always @(posedge clk or negedge rst_n)
if(!rst_n) begin
    buffer<=0; count<=0; out_valid<=0; in_valid_d<=0;
end
else begin
    in_valid_d <= in_valid;
    out_valid <= 0;

    if(new_data) begin
        buffer <= buffer | (in_data << (count*8));
        count  <= count + 1;

        if(count + 1 == required) begin
            out_data  <= buffer | (in_data << (count*8));
            out_valid <= 1;
            buffer    <= 0;
            count     <= 0;
        end
    end
end

endmodule