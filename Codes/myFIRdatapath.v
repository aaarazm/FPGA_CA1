module myFIRdatapath(din, address, dout, input_valid, clk, rst, newInput);

    parameter InputWidth = 16, OutputWidth = 38;

    input [InputWidth-1:0] din;
    input [5:0] address;
    input input_valid, clk, rst, newInput;
    output [OutputWidth-1:0] dout;

    reg [InputWidth-1:0]  coeffs [0:63];

    wire [InputWidth-1:0] inpBufferOut;
    wire [(InputWidth*2)-1:0] multRes, multResPipe;
    wire [OutputWidth-1:0] multResExtended, addRes, result, resPipe;

    initial
    begin
    $readmemb("coeffs.txt", coeffs);
    end

    shift_reg inpBuffer #(InputWidth)
    (
        .clk(clk),
        .shift(newInput),
        .rst(rst),
        .din(din),
        .address(address),
        .dout(inpBufferOut)
    );

    multiply mult1 #(InputWidth)
    (
        .a(inpBufferOut),
        .b(coeffs[address])
        .res(multRes)
    );

    Register multPipe #(InputWidth*2)
    (
        .clk(clk),
        .rst(rst),
        .ld(1'b1),
        .regIn(multRes),
        .regOut(multResPipe)
    );

    sign_extend sign1 #((InputWidth*2), OutputWidth)
    (
        .in(multResPipe),
        .out(multResExtended)
    );

    adder add1 #(OutputWidth)
    (
        .a(multResExtended),
        .b(resPipe),
        .res(addRes)
    );

    Register Result #(OutputWidth)
    (
        .clk(clk),
        .rst(rst),
        .ld(1'b1),
        .regIn(addRes),
        .regOut(result)
    );

    Register ResultPipe #(OutputWidth)
    (
        .clk(clk),
        .rst(rst),
        .ld(1'b1),
        .regIn(result),
        .regOut(resPipe)
    );

    assign dout = result;

endmodule