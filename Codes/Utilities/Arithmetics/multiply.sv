module multiply (a, b, res);

    parameter dataWidth = 16;

    input signed [dataWidth-1:0] a, b;
    output signed [(dataWidth*2)-1:0] res;

    assign res = a * b;

endmodule