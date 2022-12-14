module Register(clk, rst, ld, regIn, regOut);

    parameter SIZE = 8;
    input clk, rst, ld;
    input [(SIZE-1):0] regIn;
    output logic [(SIZE-1):0] regOut;
    
    initial begin
        regOut = 0;
    end

    always@(posedge clk, posedge rst) begin
        if(rst)
            regOut <= 0;
        else if(ld)
            regOut <= regIn;
    end

endmodule