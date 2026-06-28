`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 21:56:14
// Design Name: 
// Module Name: dma_top
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




//module dma_top (

//    input clk,
//    input rst_n,
//    input rst_n_2,

//    input [3:0] ch_req,
//    input src_load_done,

//    input [1:0] src_size,
//    input [1:0] dst_size,

//    input src_wr_en,
//    input [4:0] src_wr_addr,
//    input [31:0] src_wr_data,

//    /* SOURCE CHANNEL OUTPUTS */
//    output [4:0] src_addr_ch0, src_addr_ch1, src_addr_ch2, src_addr_ch3,
//    output [31:0] src_data_ch0, src_data_ch1, src_data_ch2, src_data_ch3,

//    /* DEST CHANNEL OUTPUTS */
//    output [9:0] dest_addr_ch0, dest_addr_ch1, dest_addr_ch2, dest_addr_ch3,
//    output [31:0] dest_data_ch0, dest_data_ch1, dest_data_ch2, dest_data_ch3,

//    output reg [1:0] src_channel,

//    output reg [1:0] dst_channel,

//    /* HANDSHAKE */
//    output src_req,
//    output src_ready,
//    output dst_req,
//    output dst_ready,

//    output dma_active,
//    output data_done,
//    output wd_timeout,
//    output final_ack
//);

//////////////////////////////////////////////////////////
//// 1. CHANNEL MAPPING 
//////////////////////////////////////////////////////////
//always @(*) begin
//case({src_size,dst_size})
//4'b0101: begin src_channel=0; dst_channel=3; end
//4'b0110: begin src_channel=0; dst_channel=2; end
//4'b0111: begin src_channel=1; dst_channel=0; end
//4'b1001: begin src_channel=1; dst_channel=2; end
//4'b1010: begin src_channel=2; dst_channel=3; end
//4'b1011: begin src_channel=2; dst_channel=0; end
//4'b1101: begin src_channel=3; dst_channel=1; end
//4'b1110: begin src_channel=3; dst_channel=0; end
//4'b1111: begin src_channel=0; dst_channel=2; end
//default: begin src_channel=0; dst_channel=0; end
//endcase

//end

//////////////////////////////////////////////////////////
//// 2. CONTROL FSM 
//////////////////////////////////////////////////////////
//wire data_fsm_en;

//control_fsm CTRL (
//    .clk(clk),
//    .rst_n(rst_n),
//    .ch_req(ch_req),
//    .data_done(data_done),
//    .wd_timeout(wd_timeout),
//    .dma_active(dma_active),
//    .data_fsm_en(data_fsm_en)
//);

//////////////////////////////////////////////////////////
//// 3. DATA FSM
//////////////////////////////////////////////////////////
//wire src_req_i, dst_req_i, dst_ready_i;
//wire [4:0] src_addr;

//data_fsm FSM (
//    .clk(clk),
//    .rst_n(rst_n),
//    .enable(data_fsm_en),

//    .src_ready(src_ready),   // IMPORTANT 
//    .dst_ready(dst_ready_i),

//    .src_req(src_req_i),
//    .dst_req(dst_req_i),

//    .data_done(data_done),
//    .final_ack(final_ack),
//    .src_index(src_addr)
//);

//assign src_req = src_req_i;
//assign dst_req = dst_req_i;

//////////////////////////////////////////////////////////
//// 4. SOURCE INTERFACES
//////////////////////////////////////////////////////////
//wire [31:0] s0,s1,s2,s3;
//wire r0,r1,r2,r3;

//source_interface S0(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==0)?src_req_i:0,r0,src_addr,s0);
//source_interface S1(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==1)?src_req_i:0,r1,src_addr,s1);
//source_interface S2(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==2)?src_req_i:0,r2,src_addr,s2);
//source_interface S3(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==3)?src_req_i:0,r3,src_addr,s3);

//assign src_ready = (src_channel==0)?r0:(src_channel==1)?r1:(src_channel==2)?r2:r3;

//////////////////////////////////////////////////////////
//// 5. SOURCE OUTPUT GATING
//////////////////////////////////////////////////////////
//assign src_addr_ch0 = (src_channel==0)?src_addr:0;
//assign src_addr_ch1 = (src_channel==1)?src_addr:0;
//assign src_addr_ch2 = (src_channel==2)?src_addr:0;
//assign src_addr_ch3 = (src_channel==3)?src_addr:0;

//assign src_data_ch0 = (src_channel==0)?s0:0;
//assign src_data_ch1 = (src_channel==1)?s1:0;
//assign src_data_ch2 = (src_channel==2)?s2:0;
//assign src_data_ch3 = (src_channel==3)?s3:0;

//////////////////////////////////////////////////////////
//// 6. SOURCE MUX
//////////////////////////////////////////////////////////
//wire [31:0] src_data;

//source_mux_4ch SRC_MUX (
//    .sel(src_channel),
//    .d0(s0), .d1(s1), .d2(s2), .d3(s3),
//    .y(src_data)
//);

//////////////////////////////////////////////////////////
//// 7. DATA PATH
//////////////////////////////////////////////////////////
//wire [31:0] dd,cd,sd;
//wire dv,cv,sv;

//data_direct   D  (src_ready,src_data,dv,dd);
//data_combiner C  (clk,rst_n,src_ready,src_data,src_size,dst_size,cv,cd);
//data_splitter S  (clk,rst_n,src_ready,src_data,src_size,dst_size,sv,sd);

//wire [31:0] dst_data =
//(src_size==dst_size)?dd:
//(src_size<dst_size)?cd:sd;

//////////////////////////////////////////////////////////
//// 8. DESTINATION INTERFACES
//////////////////////////////////////////////////////////
//wire dr0,dr1,dr2,dr3;
//wire ack0,ack1,ack2,ack3;

//destination_interface D0(clk,rst_n,(dst_channel==0)?dst_req_i:0,dr0,dest_addr_ch0,dst_data,ack0);
//destination_interface D1(clk,rst_n,(dst_channel==1)?dst_req_i:0,dr1,dest_addr_ch1,dst_data,ack1);
//destination_interface D2(clk,rst_n,(dst_channel==2)?dst_req_i:0,dr2,dest_addr_ch2,dst_data,ack2);
//destination_interface D3(clk,rst_n,(dst_channel==3)?dst_req_i:0,dr3,dest_addr_ch3,dst_data,ack3);

//assign dst_ready_i = (dst_channel==0)?dr0:(dst_channel==1)?dr1:(dst_channel==2)?dr2:dr3;
//assign dst_ready   = dst_ready_i;

//////////////////////////////////////////////////////////

//// 9. DESTINATION MUX (NOW USED)
//////////////////////////////////////////////////////////
//wire dst_ack;

//destination_mux_4ch DEST_MUX (
//    .sel(dst_channel),
//    .a0(ack0), .a1(ack1), .a2(ack2), .a3(ack3),
//    .y(dst_ack)
//);

//////////////////////////////////////////////////////////
//// 10. ADDRESS LOGIC
//////////////////////////////////////////////////////////
//reg [9:0] addr;

//always @(posedge clk or negedge rst_n)
//if(!rst_n) addr <= 0;
//else if(!dma_active) addr <= 0;
//else if(dst_ready_i) addr <= addr + 1;

//assign dest_addr_ch0 = (dst_channel==0)?addr:0;
//assign dest_addr_ch1 = (dst_channel==1)?addr:0;
//assign dest_addr_ch2 = (dst_channel==2)?addr:0;
//assign dest_addr_ch3 = (dst_channel==3)?addr:0;

//assign dest_data_ch0 = (dst_channel==0)?dst_data:0;
//assign dest_data_ch1 = (dst_channel==1)?dst_data:0;
//assign dest_data_ch2 = (dst_channel==2)?dst_data:0;
//assign dest_data_ch3 = (dst_channel==3)?dst_data:0;

//////////////////////////////////////////////////////////
//// 11. WATCHDOG (
//////////////////////////////////////////////////////////
//watchdog_timer #(5) WD (
//    .clk(clk),
//    .rst_n(rst_n),
//    .start(dst_req_i & ~dst_ready_i),
//    .ack(dst_ack),
//    .timeout(wd_timeout)
//);

//endmodule


module dma_top (

    input clk,
    input rst_n,

    input [3:0] ch_req,
    input src_load_done,

    input [1:0] src_size,
    input [1:0] dst_size,

    input src_wr_en,
    input [4:0] src_wr_addr,
    input [31:0] src_wr_data,

    input delay_enable,

    /* SOURCE CHANNEL OUTPUTS */
    //output [4:0] src_addr_ch0, src_addr_ch1, src_addr_ch2, src_addr_ch3,
    //output [31:0] src_data_ch0, src_data_ch1, src_data_ch2, src_data_ch3,

    /* DEST CHANNEL OUTPUTS */
    //output [9:0] dest_addr_ch0, dest_addr_ch1, dest_addr_ch2, dest_addr_ch3,
    //output [31:0] dest_data_ch0, dest_data_ch1, dest_data_ch2, dest_data_ch3,

    output reg [1:0] src_channel,
    output reg [1:0] dst_channel,

    /* HANDSHAKE */
    output src_req,
    output src_ready,
    output dst_req,
    output dst_ready,

    output dma_active,
    output data_done,
    output wd_timeout,
    output final_ack
);



////////////////////////////////////////////////////////
// 1. CHANNEL MAPPING
////////////////////////////////////////////////////////
always @(*) begin
case({src_size,dst_size})
4'b0101: begin src_channel=0; dst_channel=3; end
4'b0110: begin src_channel=0; dst_channel=2; end
4'b0111: begin src_channel=1; dst_channel=0; end
4'b1001: begin src_channel=1; dst_channel=2; end
4'b1010: begin src_channel=2; dst_channel=3; end
4'b1011: begin src_channel=2; dst_channel=0; end
4'b1101: begin src_channel=3; dst_channel=1; end
4'b1110: begin src_channel=3; dst_channel=0; end
4'b1111: begin src_channel=0; dst_channel=2; end
default: begin src_channel=0; dst_channel=0; end
endcase
end

////////////////////////////////////////////////////////
// 2. CONTROL FSM
////////////////////////////////////////////////////////
wire data_fsm_en;

control_fsm CTRL (
    .clk(clk),
    .rst_n(rst_n),
    .ch_req(ch_req),
    .data_done(data_done),
    .wd_timeout(wd_timeout),
    .dma_active(dma_active),
    .data_fsm_en(data_fsm_en)
);

////////////////////////////////////////////////////////
// 3. DATA FSM
////////////////////////////////////////////////////////
wire src_req_i, dst_req_i, dst_ready_i;
wire [4:0] src_addr;

data_fsm FSM (
    .clk(clk),
    .rst_n(rst_n),
    .enable(data_fsm_en),
    .src_ready(src_ready),
    .dst_ready(dst_ready_i),
    .src_req(src_req_i),
    .dst_req(dst_req_i),
    .data_done(data_done),
    .final_ack(final_ack),
    .src_index(src_addr)
);

assign src_req = src_req_i;
assign dst_req = dst_req_i;

////////////////////////////////////////////////////////
// 4. SOURCE INTERFACES
////////////////////////////////////////////////////////
wire [31:0] s0,s1,s2,s3;
wire r0,r1,r2,r3;

source_interface S0(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==0)?src_req_i:0,r0,src_addr,s0);
source_interface S1(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==1)?src_req_i:0,r1,src_addr,s1);
source_interface S2(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==2)?src_req_i:0,r2,src_addr,s2);
source_interface S3(clk,rst_n,src_wr_en,src_wr_addr,src_wr_data,(src_channel==3)?src_req_i:0,r3,src_addr,s3);

assign src_ready = (src_channel==0)?r0:(src_channel==1)?r1:(src_channel==2)?r2:r3;

////////////////////////////////////////////////////////
// 5. SOURCE OUTPUT GATING (FIXED)
////////////////////////////////////////////////////////
assign src_addr_ch0 = (src_channel==0)?src_addr:0;
assign src_addr_ch1 = (src_channel==1)?src_addr:0;
assign src_addr_ch2 = (src_channel==2)?src_addr:0;
assign src_addr_ch3 = (src_channel==3)?src_addr:0;

assign src_data_ch0 = (src_channel==0)?s0:0;
assign src_data_ch1 = (src_channel==1)?s1:0;
assign src_data_ch2 = (src_channel==2)?s2:0;
assign src_data_ch3 = (src_channel==3)?s3:0;

////////////////////////////////////////////////////////
// 6. SOURCE MUX
////////////////////////////////////////////////////////
wire [31:0] src_data;

source_mux_4ch SRC_MUX (
    .sel(src_channel),
    .d0(s0), .d1(s1), .d2(s2), .d3(s3),
    .y(src_data)
);

////////////////////////////////////////////////////////
// 7. DATA PATH
////////////////////////////////////////////////////////
wire [31:0] dd,cd,sd;
wire dv,cv,sv;

data_direct   D (src_ready,src_data,dv,dd);
data_combiner C (clk,rst_n,src_ready,src_data,src_size,dst_size,cv,cd);
data_splitter S (clk,rst_n,src_ready,src_data,src_size,dst_size,sv,sd);

wire [31:0] dst_data =
(src_size==dst_size)?dd:
(src_size<dst_size)?cd:sd;

////////////////////////////////////////////////////////
// 8. DESTINATION INTERFACES
////////////////////////////////////////////////////////
wire dr0,dr1,dr2,dr3;
wire ack0,ack1,ack2,ack3;

destination_interface D0(clk,rst_n,(dst_channel==0)?dst_req_i:0,dr0,dest_addr_ch0,dst_data,ack0,delay_enable);
destination_interface D1(clk,rst_n,(dst_channel==1)?dst_req_i:0,dr1,dest_addr_ch1,dst_data,ack1,delay_enable);
destination_interface D2(clk,rst_n,(dst_channel==2)?dst_req_i:0,dr2,dest_addr_ch2,dst_data,ack2,delay_enable);
destination_interface D3(clk,rst_n,(dst_channel==3)?dst_req_i:0,dr3,dest_addr_ch3,dst_data,ack3,delay_enable);

assign dst_ready_i = (dst_channel==0)?dr0:(dst_channel==1)?dr1:(dst_channel==2)?dr2:dr3;
assign dst_ready   = dst_ready_i;

////////////////////////////////////////////////////////
// 9. DESTINATION MUX (FIXED)
////////////////////////////////////////////////////////
wire dst_ack;

destination_mux_4ch DEST_MUX (
    .sel(dst_channel),
    .a0(ack0),
    .a1(ack1),
    .a2(ack2),
    .a3(ack3),
    .y(dst_ack)
);

////////////////////////////////////////////////////////
// 10. ADDRESS LOGIC
////////////////////////////////////////////////////////
reg [9:0] addr;

always @(posedge clk or negedge rst_n)
if(!rst_n) addr <= 0;
else if(!dma_active) addr <= 0;
else if(dst_ready_i) addr <= addr + 1;

assign dest_addr_ch0 = (dst_channel==0)?addr:0;
assign dest_addr_ch1 = (dst_channel==1)?addr:0;
assign dest_addr_ch2 = (dst_channel==2)?addr:0;
assign dest_addr_ch3 = (dst_channel==3)?addr:0;

assign dest_data_ch0 = (dst_channel==0)?dst_data:0;
assign dest_data_ch1 = (dst_channel==1)?dst_data:0;
assign dest_data_ch2 = (dst_channel==2)?dst_data:0;
assign dest_data_ch3 = (dst_channel==3)?dst_data:0;

////////////////////////////////////////////////////////
// 11. WATCHDOG
////////////////////////////////////////////////////////
watchdog_timer #(5) WD (
    .clk(clk),
    .rst_n(rst_n),
    .start(dst_req_i),
    .done(dst_ack),
    .timeout(wd_timeout)
);

endmodule
