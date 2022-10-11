module myFIRctrl (clk, rst, inputValid, outputValid, address, flush, shift);

    input clk, rst, inputValid;
    output logic outputValid, flush, shift;
    output [5:0] address;

    logic [1:0] ps, ns;

    logic [6:0] countCycles = 7'b0000000;
    logic [5:0] countAddr = 6'b000000;

    assign address = countAddr;

    parameter [1:0] input_valid = 0, init = 1, execute = 2, output_valid = 3;

    always @(ps, inputValid, countCycles) begin // does countCycles need to be at sensitivity list?
        ns = input_valid;
        case(ps)
            input_valid: ns = inputValid ? init : input_valid;

            init: ns = execute;

            execute: begin
                if(countCycles == 64)
                    ns = output_valid;
                else
                    ns = execute;
            end

            output_valid: ns = input_valid;
        endcase
    end

    always @(ps) begin
        flush = 1'b0; outputValid = 1'b0; shift = 1'b0;
        case(ps)
            //input_valid:

            init: begin
                countCycles = 1'b0;
                countAddr <= 1'b0;
                shift = 1'b1;
                flush = 1'b1;
            end

            execute: begin
                countCycles = countCycles + 1;
                countAddr <= countAddr + 1;
            end

            output_valid: outputValid = 1'b1;
        endcase
    end

    always @(posedge clk) begin
        if(rst)
            ps <= input_valid;
        else
            ps <= ns;
    end

endmodule