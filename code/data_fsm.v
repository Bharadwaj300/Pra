`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 13:55:34
// Design Name: 
// Module Name: data_fsm
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




module data_fsm(
input clk,
input rst_n,
input enable,

input src_ready,
input dst_ready,

output reg src_req,
output reg dst_req,

output reg data_done,
output reg final_ack,
output reg [4:0] src_index
);

reg [2:0] state, next_state;
reg [4:0] count;

parameter IDLE      = 3'd0,
          REQ_SRC   = 3'd1,
          WAIT_SRC  = 3'd2,
          REQ_DST   = 3'd3,
          WAIT_DST  = 3'd4,
          UPDATE    = 3'd5,
          DONE      = 3'd6;

always @(posedge clk or negedge rst_n)
if(!rst_n) state <= IDLE;
else state <= next_state;

always @(*) begin
    case(state)
        IDLE:      next_state = enable ? REQ_SRC : IDLE;
        REQ_SRC:   next_state = WAIT_SRC;
        WAIT_SRC:  next_state = src_ready ? REQ_DST : WAIT_SRC;
        REQ_DST:   next_state = WAIT_DST;
        WAIT_DST:  next_state = dst_ready ? UPDATE : WAIT_DST;
        UPDATE:    next_state = (count == 20) ? DONE : REQ_SRC;
        DONE:      next_state = enable ? DONE : IDLE;
        default:   next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n)
if(!rst_n) begin
    src_req<=0; dst_req<=0;
    src_index<=0; count<=0;
    data_done<=0; final_ack<=0;
end
else begin
    case(state)

        IDLE: begin
            src_req<=0; dst_req<=0;
            src_index<=0; count<=0;
            data_done<=0; final_ack<=0;
        end

        REQ_SRC: begin
            src_req<=1;
            dst_req<=0;
        end

        WAIT_SRC: begin
            src_req<=1;
            dst_req<=0;
        end

        REQ_DST: begin
            src_req<=0;
            dst_req<=1;
        end

        WAIT_DST: begin
            src_req<=0;
            dst_req<=1;
        end

        UPDATE: begin
            src_index <= src_index + 1;
            count     <= count + 1;
            src_req   <= 0;
            dst_req   <= 0;
        end

        DONE: begin
            data_done<=1;
            final_ack<=1;
            src_req<=0;
            dst_req<=0;
        end

    endcase
end

endmodule
