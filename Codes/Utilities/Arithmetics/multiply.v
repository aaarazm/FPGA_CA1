module multiply (a, b, res);

    parameter InputWidth = 16;

    input [dataWidth-1:0] a, b;
    output [(dataWidth*2)-1:0] res;

    assign res = a * b;

endmodule