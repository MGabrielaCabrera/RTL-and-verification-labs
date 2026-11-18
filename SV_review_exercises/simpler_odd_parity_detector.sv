// Combinational circuit that takes an 8-bit input and outputs 1 if the number of 
// ones in the input is odd (odd parity), and 0 otherwise.

module parity_detector (
  input  logic [7:0] data,
  output logic       parity
);
  assign parity = ^(data); // XOR
endmodule