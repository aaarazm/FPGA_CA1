module myFIRdatapath(din, coeff_addr, dout, output_valid, input_valid, clk, rst);
    
    parameter InputWidth = 16, OutputWidth = 38;

    input [InputWidth-1:0] din;
    input [5:0] coeff_addr;

endmodule