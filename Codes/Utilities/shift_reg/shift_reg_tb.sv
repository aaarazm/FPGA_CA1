`timescale 1ns/1ns
module shift_reg_tb;
    parameter dataWidth = 16;
    logic clk = 1'b0, shift = 1'b0, rst;
    logic [dataWidth-1:0] din;
    logic [5:0] address = 6'b000000;
    wire [dataWidth-1:0] dout;

    shift_reg #(dataWidth) UUT (
        .clk(clk),
        .shift(shift),
        .rst(rst),
        .din(din),
        .address(address),
        .dout(dout)
    );

    always #10 clk <= ~clk;
    initial begin
        rst = 1'b0;
        #31 rst = 1'b1;
        #20 rst = 1'b0;
        #23 din = 16'h0001;
        #25 shift = 1'b1;
        #51 din = 16'hffff;
        #20 address = 6'b000010;
        #27 din = 16'h00ff;
        #200 $stop;
    end
endmodule