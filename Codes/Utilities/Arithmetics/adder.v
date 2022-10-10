module adder (a, b, res);

    parameter dataWidth = 38;

    input signed [dataWidth-1:0] a, b;
    output signed [dataWidth-1:0] res;

    assign res = a + b;

endmodule