module myFIR(clk, rst, inputValid, FIR_input, outputValid, FIR_output);

<<<<<<< HEAD
    parameter InputWidth = 16, OutputWidth = 38, FIR_size = 64;
    localparam address_size = $clog2(FIR_size);
=======
    parameter InputWidth = 16, OutputWidth = 38;
>>>>>>> parent of ed73973 (changes from backup files uploaded)

    input clk, rst, inputValid;
    input  [InputWidth-1:0]  FIR_input;
    output [OutputWidth-1:0] FIR_output;
    output outputValid;

<<<<<<< HEAD
    wire flush, shift, freeze;
    wire [address_size-1:0] address;
=======
    wire flush, shift;
    wire [5:0] address;
>>>>>>> parent of ed73973 (changes from backup files uploaded)

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