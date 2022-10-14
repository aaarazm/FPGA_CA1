module myFIRctrl (clk, rst, inputValid, outputValid, address, flush, shift, freeze);

    parameter FIR_size = 64;
    localparam address_size = $clog2(FIR_size);

    input clk, rst, inputValid;
    output logic outputValid, flush, shift, freeze;
    output [address_size-1:0] address;

    logic [2:0] ps, ns;

    logic [address_size:0] countCycles = 0;
    logic [address_size-1:0] countAddr = 0;

    assign address = countAddr;

    parameter [2:0] input_valid = 0, init = 1, waitForShift = 2, execute = 3, output_valid = 4;

    always @(ps, inputValid, countCycles) begin: FSM1 // does countCycles need to be at sensitivity list?
        ns = input_valid;
        case(ps)
            input_valid: ns = inputValid ? init : input_valid;

            init: ns = waitForShift;

            waitForShift: ns = execute;

            execute: begin
                if(countCycles == FIR_size)
                    ns = output_valid;
                else
                    ns = execute;
            end

            output_valid: ns = input_valid;
        endcase
    end

    always @(ps) begin: FSM2
        flush = 1'b0; outputValid = 1'b0; shift = 1'b0; freeze = 1'b0;
        case(ps)
            //input_valid:

            init: begin
                // countCycles = 0;
                // countAddr <= 0;
                shift = 1'b1;
                flush = 1'b1;
            end

            //execute:

            output_valid: begin
                outputValid = 1'b1;
                freeze = 1'b1;
            end
        endcase
    end

    always @(posedge clk) begin: counting
        countCycles <= (ns == execute) ? (countCycles + 1) : 0;
        countAddr <= (ns == execute) ? (countAddr + 1) : 0;
    end


    always @(posedge clk) begin: next_state
        if(rst)
            ps <= input_valid;
        else
            ps <= ns;
    end

endmodule