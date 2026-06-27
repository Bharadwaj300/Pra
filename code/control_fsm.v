`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 13:56:21
// Design Name: 
// Module Name: control_fsm
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




module control_fsm(
input clk,
input rst_n,
input [3:0] ch_req,
input data_done,
input wd_timeout,
output reg dma_active,
output reg data_fsm_en
);

reg [1:0] state, next_state;

parameter IDLE      = 2'd0,
          START     = 2'd1,
          WAIT_DONE = 2'd2,
          COMPLETE  = 2'd3;

always @(posedge clk or negedge rst_n)
if(!rst_n) state <= IDLE;
else state <= next_state;

always @(*) begin
    case(state)
        IDLE:       next_state = (|ch_req) ? START : IDLE;
        START:      next_state = WAIT_DONE;
        WAIT_DONE:  next_state = data_done ? COMPLETE :
                                wd_timeout ? IDLE : WAIT_DONE;
        COMPLETE:   next_state = IDLE;
        default:    next_state = IDLE;
    endcase
end

always @(*) begin
    dma_active  = 0;
    data_fsm_en = 0;

    case(state)
        START,
        WAIT_DONE: begin
            dma_active  = 1;
            data_fsm_en = 1;
        end
    endcase
end

endmodule