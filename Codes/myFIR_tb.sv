`timescale 1ns/1ns
module myFIR_tb;

<<<<<<< HEAD
    parameter InputWidth = 16, OutputWidth = 38,  FIR_size = 64, memLength = 221184;
=======
    parameter InputWidth = 16, OutputWidth = 38, memLength = 221184;
>>>>>>> parent of ed73973 (changes from backup files uploaded)

    logic [InputWidth-1:0]   din;
    wire  [OutputWidth-1:0]  dout;
    wire outputValid;

    logic [OutputWidth-1:0]  expected_outputs [0:memLength];
    logic [InputWidth-1:0]   input_data       [0:memLength];
    logic [OutputWidth-1:0]  temp_out;
    logic clkk = 1'b0, rst_n, inputValid;
    integer inputCount = 0;

    myFIR uut1
    (
        .clk(clkk),
        .rst(rst_n),
        .inputValid(inputValid),
        .FIR_input(input_data[inputCount]),
        .outputValid(outputValid),
        .FIR_output(temp_out)
    );

    initial begin
        $readmemb("inputs.txt", input_data);
        $readmemb("outputs.txt", input_data);
    end

    always #10 clkk <= ~clkk;

    logic ps, ns;
    parameter [1:0] input_valid = 0, increment = 1, wait_for_output = 2;

    always @(ps, outputValid) begin: FSM_ns
        ns = input_valid;
        case(ps)
            input_valid: ns = increment;
            increment: ns = wait_for_output;
            wait_for_output: ns = outputValid ? input_valid : wait_for_output;
        endcase
    end

    always @(ps) begin: FSM_signals
        inputValid = 1'b0;
        case(ps)
            input_valid: inputValid = 1'b1;
            increment: inputCount = inputCount + 1;
        endcase
    end


    always @(posedge clkk) begin: next_state
        if(rst_n)
            ps <= inputValid;
        else
            ps <= ns;
    end

    initial begin
        #2 rst_n = 1'b1;
        #13 rst_n = 1'b0;
        #1000 $stop;
    end

endmodule