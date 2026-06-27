`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 21:59:31
// Design Name: 
// Module Name: source_interface
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


module source_interface(
input clk,
input rst_n,
input wr_en,
input [4:0] wr_addr,
input [31:0] wr_data,
input src_req,
output reg src_ready,
input [4:0] rd_addr,
output reg [31:0] rd_data
);

reg [31:0] mem [0:19];
reg [31:0] pipe;
reg req_d;

always @(posedge clk or negedge rst_n)
if(!rst_n) begin
    src_ready<=0;
    rd_data<=0;
    req_d<=0;
end
else begin
    req_d <= src_req;

    if(src_req)
        pipe <= mem[rd_addr];

    if(req_d)

        rd_data <= pipe;

    src_ready <= req_d;

    if(wr_en)
        mem[wr_addr] <= wr_data;
end

endmodule

