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
6. Design a parameterizable N-bit counter whose output is in Gray code. Internally, keep a
   binary counter and convert it to Gray code. Include a synchronous active-high reset and
   an enable signal. Also provide a function that converts Gray code back to binary, and 
   use it in a separate output bin_out for debugging.
7. Design a CDC module that transfers a single-bit pulse from clock domain clk_a to clock 
   domain clk_b, where the two clocks are asynchronous. Use a toggle synchronizer: convert 
   the pulse into a toggle in the source domain, synchronize the toggle with a 
   two-flip-flop chain in the destination domain, and detect the edge to regenerate the 
   pulse. Assume pulses in clk_a are separated by enough cycles for the transfer to 
   complete.
8. Mealy FSM for a vending machine that sells one product for 15 cents. It accepts only 
   nickels (5 cents) and dimes (10 cents), never both in the same cycle. 
   The output dispense must go high in the same cycle in which the coin that completes 
   (or exceeds) 15 cents is inserted. After dispensing, the machine returns to the initial 
   state. No change is given back. Use an enumerated type and a synchronous active-high 
   reset.
9. Create a stream_if interface with a valid/ready handshake carrying a parameterizable-width
   data bus. Define two modports, source and sink. Then design a producer module that sends 
   the values 0, 1, 2, ... (one per transfer), and a consumer module that accumulates the 
   received values into a sum register. A transfer happens on a clock edge where both valid 
   and ready are high. The consumer’s ready is driven by an external stall input 
   (ready = ~stall). Connect everything in a top module.
10. Design a traffic light controller whose states are an enum RED, GREEN, YELLOW. Each state
    lasts a different number of clock cycles (RED = 6, GREEN = 4, YELLOW = 2). When the timer
    expires, advance to the following state using the enum method next() (no case for the 
    transitions). Then write a testbench-style initial block that: (1) iterates over all the 
    enum values using first(), next() and num() and prints each one with name(), and (2) 
    prints the state on every clock cycle for 30 cycles.
11. Design a parameterizable synchronous FIFO with DATA_WIDTH bits and DEPTH entries (DEPTH
    is a power of two). It has a single clock, a synchronous active-high reset, write enable 
    wr_en, read enable rd_en, and flags full and empty. A write when full and a read when 
    empty must be ignored. The read data rd_data must show the oldest element combinationally 
    (mem[rd_ptr]), so the data is available in the same cycle in which empty is low. Also 
    provide an output count with the number of stored elements.

