// Parameterizable N-bit counter whose output is in Gray code. Internally, keep a
// binary counter and convert it to Gray code. Include a synchronous active-high reset and
// an enable signal. Also provide a function that converts Gray code back to binary, and 
// use it in a separate output bin_out for debugging.

module gray_counter #(
  parameter int N = 4
) (
  input  logic         clk,
  input  logic         reset,
  input  logic         enable,
  output logic [N-1:0] gray_out,
  output logic [N-1:0] bin_out
);
  logic [N-1:0] bin_count;

  function automatic logic [N-1:0] bin_to_gray(logic [N-1:0] bin_value);
    return bin_value ^ (bin_value >> 1'b1);
  endfunction

  function automatic logic [N-1:0] gray_to_bin(logic [N-1:0] gray_value);
    logic [N-1:0] bin_value;
    for (int i = 0; i < N; i++) begin
        bin_value[i] = ^(gray_value >> i);
    end
    return bin_value;
  endfunction

  // Binary counter 
  always_ff @(posedge clk) begin
    if (reset)
        bin_count <= 0;
    else if (enable)
        bin_count <= bin_count + 1'b1;
  end

  assign gray_out = bin_to_gray(bin_count);
  assign bin_out = gray_to_bin(gray_out);

endmodule