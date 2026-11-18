// Reset synchronizer. The module receives an asynchronous active-low reset arst_n
// and must produce srst_n, which asserts asynchronously but deasserts synchronously with 
// clk. Use a two-flip-flop chain. Then, use srst_n to reset an 8-bit register q that loads
// d on every clock edge.

module reset_sync_reg (
  input  logic       clk,
  input  logic       arst_n,
  input  logic [7:0] d,
  output logic [7:0] q
);
  logic srst_n;
  logic srst_n_t;

  always_ff @(posedge clk or negedge arst_n) begin
    if (!arst_n) begin
        srst_n_t <= 1'b0;
        srst_n <= 1'b0;
    end else begin
        srst_n_t <= 1'b1;
        srst_n <= srst_n_t; 
    end
  end

  always_ff @(posedge clk or negedge srst_n) begin
    if (!srst_n)
        q <= 8'h00;
    else
        q <= d;
  end

  
endmodule