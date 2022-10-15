`timescale 1ns/1ns
module myFIR_tb;

    parameter InputWidth = 16, OutputWidth = 38,  FIR_size = 64,memLength = 221184;

    logic [InputWidth-1:0]   din;
    wire  [OutputWidth-1:0]  dout;
    wire outputValid;

    logic [OutputWidth-1:0]  expected_outputs [0:memLength];
    logic [InputWidth-1:0]   input_data       [0:memLength];
    logic [OutputWidth-1:0]  temp_out;
    logic clkk = 1'b0, rst_n, inputValid;
    integer inputCount = 0;

    myFIR #(InputWidth, OutputWidth, FIR_size) uut1
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
    end

    initial begin
        $readmemb("outputs.txt", expected_outputs);
    end

    localparam period = 20;
    always #(period/2) clkk <= ~clkk;

    logic [1:0] ps, ns;
    parameter [1:0] input_valid = 0, waitForShift = 1, increment = 2, wait_for_output = 3;

    always @(ps, outputValid) begin: FSM1
        ns = input_valid;
        case(ps)
            input_valid: ns = waitForShift;
            waitForShift: ns = increment;
            increment: ns = wait_for_output;
            wait_for_output: ns = outputValid ? input_valid : wait_for_output;
        endcase
    end

    always @(ps) begin: FSM2
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
        #275000000 $stop;
    end

    //assertions begin >>

    property outVal;
        @(posedge clkk) $rose(outputValid) |-> (temp_out == expected_outputs[inputCount-1]);
    endproperty
    checkOut: assert property (outVal) $display($stime,,,"\t\tOut PASS"); else $display($stime,,,"\tOutput FAIL");

    property checkMult;
        @(posedge clkk) disable iff(inputCount > 4) (1'b1==1'b1) |->((uut1.uut1.mult1.a * uut1.uut1.mult1.b) == uut1.uut1.mult1.res);
    endproperty
    checkingMult: assert property (checkMult) $display($stime,,,"\t\tMult PASS"); else $display($stime,,,"\tMult FAIL");

    property checkAdd;
        @(posedge clkk) disable iff(inputCount > 4) (1'b1==1'b1) |->((uut1.uut1.add1.a + uut1.uut1.add1.b) == uut1.uut1.add1.res);
    endproperty
    checkingAdd: assert property (checkAdd) $display($stime,,,"\t\tAdd PASS"); else $display($stime,,,"\tAdd FAIL");

    property checkCtrlAddr;
        @(posedge clkk) disable iff(inputCount > 6) (uut1.uut2.ps == 3) |-> ($past(uut1.uut2.countAddr) == (uut1.uut2.countAddr-1));
    endproperty
    checkingCtrlAddr: assert property (checkCtrlAddr) $display($stime,,,"\t\tCounter is counting!"); 
    else $display($stime,,,"\tCounter isn't counting");

    //assertions end.

endmodule