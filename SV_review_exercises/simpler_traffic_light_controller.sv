// Traffic light controller whose states are an enum RED, GREEN, YELLOW. Each state
// lasts a different number of clock cycles (RED = 6, GREEN = 4, YELLOW = 2). When the timer
// expires, advance to the following state using the enum method next() (no case for the 
// transitions). Then write a testbench-style initial block that: (1) iterates over all the 
// enum values using first(), next() and num() and prints each one with name(), and (2) 
// prints the state on every clock cycle for 30 cycles.

package light_pkg;
    typedef enum logic [1:0] {RED, GREEN, YELLOW} light_t;
endpackage

module traffic_light
    import light_pkg::*;
(
  input  logic clk,
  input  logic reset,
  output logic red,
  output logic green,
  output logic yellow
);

  light_t      state;
  logic [2:0]  timer;

  function automatic logic [2:0] duration(light_t s);
    case (s)
        RED: return 6;
        GREEN: return 4;
        YELLOW: return 2;
        default: return 6; // RED
    endcase
  endfunction

  always_ff @(posedge clk) begin
    if (reset) begin
        timer <= 0;
        state <= RED;   
    end
    else if (timer == duration(state) - 1'b1) begin
        state <= state.next();
        timer <= 3'd0; 
    end
    else
        timer <= timer + 1'b1;
  end

  assign red = (state == RED);
  assign green = (state == GREEN);
  assign yellow = (state == YELLOW);

endmodule


module tb;
    import light_pkg::*;

    logic clk = 0;
    logic reset = 1;
    logic red, green, yellow;

    logic [4:0] timer;

    light_t s;

    traffic_light dut(.*);

    always #5 clk = ~clk;

    initial begin
        
        s = s.first();
        for (int i = 0; i < s.num(); i++) begin
            $display("  [%0d] %s = %0d", i, s.name(), s);
            s = s.next();
        end

        repeat (2) @(posedge clk);
        @(negedge clk) reset = 0;

        repeat (30) begin
            @(negedge clk);
            $display("t = %0t: timer = %0d, state = %0s, red = %b, green = %b, yellow = %b",
                $time, dut.timer, dut.state.name(), red, green, yellow);
        end
        $finish;

    end


endmodule