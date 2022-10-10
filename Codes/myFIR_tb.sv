`timescale 1ns/1ns
module myFIR_tb;

    parameter InputWidth = 16, OutputWidth = 38, memLength = 221184;

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
    parameter input_valid = 0, wait_for_output = 1;

    always @(ps, outputValid) begin
        ns = input_valid;
        case(ps)
            input_valid: ns = wait_for_output;
            wait_for_output: ns = outputValid ? input_valid : wait_for_output;
        endcase
    end

    always @(ps)

    always @(posedge clkk)
