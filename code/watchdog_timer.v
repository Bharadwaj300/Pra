`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 22:16:23
// Design Name: 
// Module Name: watchdog_timer
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




module watchdog_timer #(parameter LIMIT=5)(
input clk,
input rst_n,
input start,     // when transfer begins
input done,      // when transfer completes
output reg timeout
);

reg [3:0] count;

always @(posedge clk or negedge rst_n)
if(!rst_n) begin
    count<=0;
    timeout<=0;
end
else begin

    if(start && !done) begin
        count <= count + 1;

        if(count >= LIMIT)
            timeout <= 1;
    end
    else begin
        count   <= 0;
        timeout <= 0;   // auto reset → continue next transfer
    end

end

endmodule