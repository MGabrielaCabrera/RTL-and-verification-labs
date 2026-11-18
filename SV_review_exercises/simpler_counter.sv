// 4-bit up counter with a synchronous active-high reset and an enable signal. 
// The counter should increment on every rising clock edge only when enable is high. 
// When reset is high, the counter should return to zero.

module counter4 (
  input  logic       clk,
  input  logic       reset,
  input  logic       enable,
  output logic [3:0] count
);
    always_ff @(posedge clk || posedge reset) begin
        if (reset)
            count <= 4'd0;
        else if (enable)
            count <= count +  4'd1;
    end
endmodule