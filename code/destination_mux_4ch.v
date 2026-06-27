`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 14:00:00
// Design Name: 
// Module Name: destination_mux_4ch
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



module destination_mux_4ch(
input [1:0] sel,
input a0,
input a1,
input a2,
input a3,
output reg y
);

always @(*) begin
    case(sel)
        2'd0: y=a0;
        2'd1: y=a1;
        2'd2: y=a2;
        2'd3: y=a3;
        default: y=0;
    endcase
end

endmodule
