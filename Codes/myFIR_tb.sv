
module myFIR_tb;

    parameter InputWidth = 16, OutputWidth = 38, memLength = 221184;

    logic   [InputWidth-1:0] din;
    wire  [OutputWidth-1:0] dout;
    wire output_validd;

    logic [OutputWidth-1:0]  expected_outputs [0:memLength];
    logic [InputWidth-1:0]  input_data [0:memLength];
    logic [OutputWidth-1:0]  temp_out;
    logic [InputWidth-1:0] input_buffer
    logic clkk = 1'b0, rst_n;
    integer in

    logic [5:0] buffer_addr = 6'b000000;

    initial begin
        $readmemb("inputs.txt", input_data);
        $readmemb("outputs.txt", input_data);
    end

    always #10 clkk <= ~clkk;

    logic ps, ns;
    parameter [1:0] input_valid = 0, buffer_addressing = 1;

    always @(posedge clkk) begin
        ns = input_valid;
        case(ps)
            input_valid: ns = buffer_addressing;
            buffer_addressing: ns = output_validd ? input_valid : buffer_addressing;
        endcase
    end

    always @(posedge clkk)
