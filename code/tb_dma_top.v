`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 22:17:18
// Design Name: 
// Module Name: tb_dma_top
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



module tb_dma_top;

/* CLOCK */
reg clk = 0;
always #5 clk = ~clk;

/* RESET */
reg rst_n;

/* CONTROL */
reg [3:0] ch_req;
reg src_load_done;

/* CONFIG */
reg [1:0] src_size;
reg [1:0] dst_size;

/* SOURCE WRITE */
reg        src_wr_en;
reg [4:0]  src_wr_addr;
reg [31:0] src_wr_data;
wire [1:0] src_channel;
wire [1:0] dst_channel;

/* TIMEOUT CONTROL */
reg delay_enable;

/* ================= OUTPUT WIRES (IMPORTANT) ================= */

/* SOURCE CHANNEL OUTPUTS */
wire [4:0] src_addr_ch0, src_addr_ch1, src_addr_ch2, src_addr_ch3;
wire [31:0] src_data_ch0, src_data_ch1, src_data_ch2, src_data_ch3;

/* DEST CHANNEL OUTPUTS */
wire [9:0] dest_addr_ch0, dest_addr_ch1, dest_addr_ch2, dest_addr_ch3;
wire [31:0] dest_data_ch0, dest_data_ch1, dest_data_ch2, dest_data_ch3;

/* HANDSHAKE */
wire src_req, src_ready, dst_req, dst_ready;

/* STATUS */
wire dma_active, data_done, wd_timeout, final_ack;

/* =========================================================== */

/* DUT */
dma_top DUT(

.clk(clk),
.rst_n(rst_n),

.ch_req(ch_req),
.src_load_done(src_load_done),

.src_size(src_size),
.dst_size(dst_size),

.src_wr_en(src_wr_en),
.src_wr_addr(src_wr_addr),
.src_wr_data(src_wr_data),

.delay_enable(delay_enable),

/* SOURCE CHANNEL OUTPUTS */
.src_addr_ch0(src_addr_ch0),
.src_addr_ch1(src_addr_ch1),
.src_addr_ch2(src_addr_ch2),
.src_addr_ch3(src_addr_ch3),

.src_data_ch0(src_data_ch0),
.src_data_ch1(src_data_ch1),
.src_data_ch2(src_data_ch2),
.src_data_ch3(src_data_ch3),

/* DEST CHANNEL OUTPUTS */
.dest_addr_ch0(dest_addr_ch0),
.dest_addr_ch1(dest_addr_ch1),
.dest_addr_ch2(dest_addr_ch2),
.dest_addr_ch3(dest_addr_ch3),

.dest_data_ch0(dest_data_ch0),
.dest_data_ch1(dest_data_ch1),
.dest_data_ch2(dest_data_ch2),
.dest_data_ch3(dest_data_ch3),
.src_channel(src_channel),
.dst_channel(dst_channel),

/* HANDSHAKE */
.src_req(src_req),
.src_ready(src_ready),
.dst_req(dst_req),
.dst_ready(dst_ready),

/* STATUS */
.dma_active(dma_active),
.data_done(data_done),
.wd_timeout(wd_timeout),
.final_ack(final_ack)

);

/* =====================================================
   LOAD SOURCE MEMORY
===================================================== */
integer i;
task load_memory;
begin
    src_wr_en = 1;
    src_load_done = 0;

    for(i=0;i<20;i=i+1) begin
        @(posedge clk);
        src_wr_addr = i;
        src_wr_data = i + 1;
    end

    @(posedge clk);
    src_wr_en = 0;
    src_load_done = 1;
end
endtask

/* =====================================================
   NORMAL CASE
===================================================== */
task run_case;
input [1:0] s_size;
input [1:0] d_size;
input [3:0] channel;
begin

    delay_enable = 0;

    $display("\n====================================");
    $display("CASE: SRC=%0d DST=%0d CH=%b", s_size, d_size, channel);
    $display("====================================");

    src_size = s_size;
    dst_size = d_size;

    load_memory();

    @(posedge clk);
    ch_req = channel;

    wait(final_ack);

    if(wd_timeout)
        $display("ERROR: TIMEOUT IN NORMAL CASE");

    ch_req = 0;
    src_load_done = 0;

    repeat(10) @(posedge clk);

end
endtask

/* =====================================================
   TIMEOUT CASE
===================================================== */
task run_timeout_case;
begin

    $display("\n===== TIMEOUT TEST CASE =====");

    delay_enable = 1;

    src_size = 2'b01;
    dst_size = 2'b01;

    load_memory();

    @(posedge clk);
    ch_req = 4'b0001;

    repeat(100) @(posedge clk);

    delay_enable = 0;
    ch_req = 0;

    $display("===== TIMEOUT TEST DONE =====");

end
endtask

/* =====================================================
   MONITOR
===================================================== */
always @(posedge clk) begin

    if(src_req || dst_req) begin
        $display("T=%0t | SRC_REQ=%b SRC_RDY=%b | DST_REQ=%b DST_RDY=%b | TIMEOUT=%b",
        $time,
        src_req, src_ready,
        dst_req, dst_ready,
        wd_timeout);
    end

    if(wd_timeout)
        $display(">>> TIMEOUT DETECTED <<<");

    if(final_ack)
        $display(">>> TRANSFER COMPLETE <<<");

end

/* =====================================================
   MAIN
===================================================== */
initial begin

    rst_n = 0;
    ch_req = 0;
    src_wr_en = 0;
    delay_enable = 0;

    repeat(5) @(posedge clk);
    rst_n = 1;

    /* 9 NORMAL CASES */
    run_case(2'b01,2'b01,4'b0001);
    run_case(2'b01,2'b10,4'b0010);
    run_case(2'b01,2'b11,4'b0100);

    run_case(2'b10,2'b01,4'b0001);
    run_case(2'b10,2'b10,4'b0010);
    run_case(2'b10,2'b11,4'b0100);

    run_case(2'b11,2'b01,4'b0001);
    run_case(2'b11,2'b10,4'b0010);
    run_case(2'b11,2'b11,4'b1000);

    /* 10th CASE */
    run_timeout_case();

    #200;
    $finish;

end

endmodule