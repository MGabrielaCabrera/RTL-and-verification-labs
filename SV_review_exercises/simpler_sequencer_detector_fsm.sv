// Design a Moore FSM that detects the sequence 1011 on a serial input din, with overlapping 
// allowed. The output detected should be high for one clock cycle after the last bit of the
// sequence is received. Use an enumerated type for the states and a synchronous active-high
// reset.

module seq_detector (
  input  logic clk,
  input  logic reset,
  input  logic din,
  output logic detected
);
  typedef enum logic [2:0] {
    S_IDLE,
    S_1,
    S_10,
    S_101,
    S_1011
  } state_t;

  state_t state, next_state;

  always_ff @(posedge clk) begin
    if (reset) 
        state <= S_IDLE;
    else
        state <= next_state;
  end

  always_comb begin
    case (state)
        S_IDLE: next_state = din ? S_1: S_IDLE;
        S_1:    next_state = din ? S_1: S_10;
        S_10:   next_state = din ? S_101: S_IDLE;
        S_101:  next_state = din ? S_1011: S_10;
        S_1011: next_state = din ? S_1: S_10;
        default: next_state = S_IDLE;
    endcase
  end

  assign detected = (state == S_1011);


endmodule

module tb;

  logic clk = 1'b0;
  logic reset;
  logic din;
  logic detected;

  logic expected;
  logic [3:0] shift;
  logic stimulus [15] = '{1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0};
  int error = 0;

    always #5 clk = ~clk; // 100 MHz

    seq_detector dut(.*);

    always_ff @(posedge clk) begin
        if (reset) begin
            shift <= 4'b0000;
            expected= 1'b0;
        end
        else begin
            shift <= {shift[2:0], din};
            expected = ({shift[2:0], din} == 4'b1011);
        end 
    end

    always_ff @(negedge clk) begin
        if (reset)
            error <= 1'b0; 
        else begin
            if (expected != detected) begin
                error++;
                $error("ERROR t=%0t: din = %b, expected = %b, detected = %b", $time, din, expected, detected);
            end
        end
    end

    always_ff @(negedge clk) begin
        $display("t=%0t: din = %b, expected = %b, detected = %b", $time, din, expected, detected);
    end

    task automatic send(input logic bit_in);
        din <= bit_in;
        @(posedge clk);
    endtask

    initial begin
        reset = 1;
        din = 0;
        repeat(3) @(posedge clk);
        reset = 0;
        
        foreach (stimulus[i]) begin
            send(stimulus[i]);
        end

        repeat (20) send($urandom_range(0,1));

        $display("Simulation finished with %0d errors", error);

        $finish;

    end


endmodule