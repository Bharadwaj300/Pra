`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 22:00:16
// Design Name: 
// Module Name: destination_interface
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




module destination_interface(
input clk,
input rst_n,
input dst_req,
output reg dst_ready,
input [9:0] wr_addr,
input [31:0] wr_data,
output reg ack,
input delay_enable   // ✅ ADD THIS
);

reg [31:0] mem [0:1023];
reg req_d;
reg [3:0] delay_cnt;

always @(posedge clk or negedge rst_n)
if(!rst_n) begin
    dst_ready<=0;
    ack<=0;
    req_d<=0;
    delay_cnt<=0;
end
else begin
    req_d <= dst_req;
    ack <= 0;

    if(req_d) begin

        if(delay_enable) begin
            delay_cnt <= delay_cnt + 1;

            if(delay_cnt > 5) begin   // timeout trigger (>5 cycles)
                dst_ready <= 1;
                mem[wr_addr] <= wr_data;
                ack <= 1;
                delay_cnt <= 0;
            end
            else begin
                dst_ready <= 0;
            end
        end
        else begin
            dst_ready <= 1;
            mem[wr_addr] <= wr_data;
            ack <= 1;
            delay_cnt <= 0;
        end

    end
    else begin
        dst_ready <= 0;
        delay_cnt <= 0;
    end
end

endmodule