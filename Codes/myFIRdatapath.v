module myFIRdatapath(din, address, dout, input_valid, clk, rst);
    
    parameter InputWidth = 16, OutputWidth = 38;

    input [InputWidth-1:0] din;
    input [5:0] address;
    input input_valid, clk, rst;
    output [OutputWidth-1:0] dout;

    

endmodule