module shift_reg(clk, shift, rst, din, address, dout);
    parameter dataWidth = 16;
    input [dataWidth-1:0] din;
    input clk, shift, rst;
    input [5:0] address;
    output [dataWidth-1:0] dout;

    wire [dataWidth-1:0] J [0:64];
    assign J[0] = din;
    genvar i;
    generate
        for(i = 0; i < 64; i = i + 1) begin
            Register #(dataWidth) RXX (.clk(clk), .rst(rst), .ld(shift), .regIn(J[i]), .regOut(J[i+1]));
        end
    endgenerate
    assign dout = J[address + 1];

endmodule