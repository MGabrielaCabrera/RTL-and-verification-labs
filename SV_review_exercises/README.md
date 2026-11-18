# SystemVerilog Review exercises

1. Design a 2-to-1 multiplexer with 8-bit data inputs. When sel is 0, the output should be a;
   when sel is 1, the output should be b.
2. Design a 4-bit up counter with a synchronous active-high reset and an enable signal. 
   The counter should increment on every rising clock edge only when enable is high. 
   When reset is high, the counter should return to zero.
3. Design a combinational circuit that takes an 8-bit input and outputs 1 if the number of 
   ones in the input is odd (odd parity), and 0 otherwise.
4. Design a Moore FSM that detects the sequence 1011 on a serial input din, with overlapping 
   allowed. The output detected should be high for one clock cycle after the last bit of the
   sequence is received. Use an enumerated type for the states and a synchronous active-high
   reset.
5. Design a reset synchronizer. The module receives an asynchronous active-low reset arst_n
   and must produce srst_n, which asserts asynchronously but deasserts synchronously with 
   clk. Use a two-flip-flop chain. Then, use srst_n to reset an 8-bit register q that loads
   d on every clock edge.