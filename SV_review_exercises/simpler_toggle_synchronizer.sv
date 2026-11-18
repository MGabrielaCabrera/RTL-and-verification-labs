// CDC module that transfers a single-bit pulse from clock domain clk_a to clock 
// domain clk_b, where the two clocks are asynchronous. Use a toggle synchronizer: convert 
// the pulse into a toggle in the source domain, synchronize the toggle with a 
// two-flip-flop chain in the destination domain, and detect the edge to regenerate the 
// pulse. Assume pulses in clk_a are separated by enough cycles for the transfer to 
// complete.

module pulse_cdc (
  input  logic clk_a,
  input  logic rst_a_n,
  input  logic pulse_a,

  input  logic clk_b,
  input  logic rst_b_n,
  output logic pulse_b
);
  logic toggle_a;
  logic pulse_a_prev;
  logic sync1_b, sync2_b, sync2_b_d;

  // Toggling the pulse_a with the clock a
  always_ff @(posedge clk_a or negedge rst_a_n) begin
    if (!rst_a_n)
        toggle_a <= 1'b0;
    else begin
        pulse_a_prev <= pulse_a;
        if(!pulse_a_prev and pulse_a) 
            toggle_a <= ~toggle_a;
    end
  end

  // Synchronizing the toggled signal with the clock b + delay to reconstruct the pulse
  always_ff @(posedge clk_b or negedge rst_b_n) begin
    if (!rst_b_n) begin
        sync1_b <= 1'b0;
        sync2_b <= 1'b0;
        sync2_b_d <= 1'b0;
    end else begin
        sync1_b <= toggle_a;
        sycn2_b <= sync1_b;
        sync2_b_d <= sycn2_b;
    end
  end

  // Reconstructing the pulses
  assign pulse_b = sync2_b_d ^ sycn2_b;

endmodule

