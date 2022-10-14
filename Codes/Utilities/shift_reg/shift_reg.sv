module shift_reg(clk, shift, rst, din, address, dout);
    parameter dataWidth = 16, size = 64;
    localparam address_size = $clog2(size);
    input [dataWidth-1:0] din;
    input clk, shift, rst;
    input [address_size-1:0] address;
    output [dataWidth-1:0] dout;

    wire [dataWidth-1:0] J [0:size];
    assign J[0] = din;
    genvar i;
    generate
        for(i = 0; i < size; i = i + 1) begin: shift_reg_file
            Register #(dataWidth) RXX (.clk(clk), .rst(rst), .ld(shift), .regIn(J[i]), .regOut(J[i+1]));
        end
    endgenerate
    assign dout = J[address + 1];

endmodule