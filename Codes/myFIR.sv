module myFIR(clk, rst, inputValid, FIR_input, outputValid, FIR_output);

    parameter InputWidth = 16, OutputWidth = 38, FIR_size = 64;
    localparam address_size = $clog2(FIR_size);

    input clk, rst, inputValid;
    input  [InputWidth-1:0]  FIR_input;
    output [OutputWidth-1:0] FIR_output;
    output outputValid;

    wire flush, shift, freeze;
    wire [address_size-1:0] address;

    myFIRdatapath #(InputWidth, OutputWidth) uut1
    (
        .din(FIR_input),
        .address(address),
        .dout(FIR_output),
        .clk(clk),
        .rst(rst),
        .shift(shift),
        .flush(flush)
    );

    myFIRctrl uut2
    (
        .clk(clk),
        .rst(rst),
        .inputValid(inputValid),
        .outputValid(outputValid),
        .address(address),
        .flush(flush),
        .shift(shift)
    );

endmodule