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
    unique case (state)
        S_IDLE: next_state = din ? S_1: S_IDLE;
        S_1:    next_state = din ? S_1: S_10;
        S_10:   next_state = din ? S_101: S_IDLE;
        S_101:  next_state = din ? S_1011: S_10;
        S_1011: next_state = din ? S_1: S_10;
    endcase
  end

  assign detected = (state == S_1011);


endmodule