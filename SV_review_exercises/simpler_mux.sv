// 2-to-1 multiplexer with 8-bit data inputs. When sel is 0, the output should be a;
// when sel is 1, the output should be b.

module mux2to1 (
  input  logic [7:0] a,
  input  logic [7:0] b,
  input  logic       sel,
  output logic [7:0] y
);
  /*always_comb begin
    if (sel)
        y = b;
    else 
        y = a;
  end*/

  assign y = sel ? b : a;

endmodule