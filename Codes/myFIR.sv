module myFIR(clk, rst, inputValid, FIR_input, outputValid, FIR_output);

    parameter InputWidth = 16, OutputWidth = 38, FIR_size = 64;

    input clk, rst, inputValid;
    input  [InputWidth-1:0]  FIR_input;
    output [OutputWidth-1:0] FIR_output;
    output outputValid;

    wire flush, shift, freeze;
    wire [5:0] address;

    myFIRdatapath #(InputWidth, OutputWidth, FIR_size) uut1
    (
        .din(FIR_input),
        .address(address),
        .dout(FIR_output),
        .clk(clk),
        .rst(rst),
        .shift(shift),
        .flush(flush),
        .freeze(freeze)
    );

    myFIRctrl #(FIR_size) uut2
    (
        .clk(clk),
        .rst(rst),
        .inputValid(inputValid),
        .outputValid(outputValid),
        .address(address),
        .flush(flush),
        .shift(shift),
        .freeze(freeze)
    );

endmodule