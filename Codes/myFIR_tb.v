
module myFIR_tb;

    parameter InputWidth = 16, OutputWidth = 38, memLength = 221184;

    reg   [InputWidth-1:0] din;
    wire  [OutputWidth-1:0] dout;
    wire output_validd;

    reg [OutputWidth-1:0]  expected_outputs [0:memLength];
    reg [InputWidth-1:0]  input_data [0:memLength];
    reg [OutputWidth-1:0]  temp_out;
    reg [InputWidth-1:0] input_buffer
    reg clkk = 1'b0, rst_n;
    integer in

    reg [5:0] buffer_addr = 6'b000000;

    initial begin
        $readmemb("inputs.txt", input_data);
        $readmemb("outputs.txt", input_data);
    end

    always #10 clkk <= ~clkk;

    reg ps, ns;
    parameter [1:0] input_valid = 0, buffer_addressing = 1;

    always @(posedge clkk) begin
        ns = input_valid;
        case(ps)
            input_valid: ns = buffer_addressing;
            buffer_addressing: ns = output_validd ? input_valid : buffer_addressing;
        endcase
    end

    always @(posedge clkk)
