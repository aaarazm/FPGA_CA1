module myFIRdatapath(din, address, dout, clk, rst, shift, flush, freeze);

    parameter InputWidth = 16, OutputWidth = 38, FIR_size = 64;

    input clk, rst, shift, flush, freeze;
    input  [InputWidth-1:0]  din;
    input  [5:0]             address;
    output [OutputWidth-1:0] dout;

    logic [InputWidth-1:0]  coeffs [0:FIR_size-1];

    wire [InputWidth-1:0]     inpBufferOut;
    wire [(InputWidth*2)-1:0] multRes, multResPipe;
    wire [OutputWidth-1:0]    multResExtended, addRes, result;

    // initial
    // begin
    // $readmemb("coeffs.txt", coeffs);
    // end

    shift_reg #(InputWidth) inpBuffer
    (
        .clk(clk),
        .shift(shift),
        .rst(rst),
        .din(din),
        .address(address),
        .dout(inpBufferOut)
    );

    multiply #(InputWidth) mult1
    (
        .a(inpBufferOut),
        .b(coeffs[address]),
        .res(multRes)
    );

    Register #(InputWidth*2) multPipe
    (
        .clk(clk),
        .rst((rst | flush | freeze)),
        .ld(1'b1),
        .regIn(multRes),
        .regOut(multResPipe)
    );

    sign_extend #((InputWidth*2), OutputWidth) sign1
    (
        .in(multResPipe),
        .out(multResExtended)
    );

    adder #(OutputWidth) add1
    (
        .a(multResExtended),
        .b(result),
        .res(addRes)
    );

    Register #(OutputWidth) Result
    (
        .clk(clk),
        .rst((rst | flush)),
        .ld(1'b1),
        .regIn(addRes),
        .regOut(result)
    );

//    Register #(OutputWidth) ResultPipe
//    (
//        .clk(clk),
//        .rst((rst | flush)),
//        .ld(1'b1),
//        .regIn(result),
//        .regOut(resPipe)
//    );

    assign dout = result;

endmodule