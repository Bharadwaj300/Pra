`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2026 13:58:41
// Design Name: 
// Module Name: source_mux_4ch
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



module source_mux_4ch(
input [1:0] sel,
input [31:0] d0,
input [31:0] d1,
input [31:0] d2,
input [31:0] d3,
output reg [31:0] y
);

always @(*) begin
    case(sel)
        2'd0: y=d0;
        2'd1: y=d1;
        2'd2: y=d2;
        2'd3: y=d3;
        default: y=0;
    endcase
end

endmodule

