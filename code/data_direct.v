`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 22:11:26
// Design Name: 
// Module Name: data_direct
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




module data_direct(
input in_valid,
input [31:0] in_data,
output out_valid,
output [31:0] out_data
);

assign out_valid = in_valid;
assign out_data = in_data;

endmodule

