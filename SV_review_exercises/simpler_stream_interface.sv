// stream_if interface with a valid/ready handshake carrying a parameterizable-width
// data bus. Define two modports, source and sink. Then design a producer module that sends 
// the values 0, 1, 2, ... (one per transfer), and a consumer module that accumulates the 
// received values into a sum register. A transfer happens on a clock edge where both valid 
// and ready are high. The consumer’s ready is driven by an external stall input 
// (ready = ~stall). Connect everything in a top module.

interface stream_if #(
    parameter int DATA_BUS_WIDTH = 8
)
(
    input logic clk
);
    logic valid;
    logic ready;
    logic [DATA_BUS_WIDTH -1: 0] data_bus;

    modport SOURCE (input clk, input ready, output valid, output data_bus);
    modport SINK (input clk, output ready, input valid, input data_bus);

endinterface

module stream_source #(
    parameter int DATA_BUS_WIDTH = 8
) (stream_if.SOURCE bus, input logic reset
 );

    logic [DATA_BUS_WIDTH -1: 0] counter;


    always_ff @(posedge bus.clk) begin
        if (reset)
            counter <= 1'b0;
        else if (bus.ready && bus.valid) 
            counter <= counter + 1'b1;
    end

    assign bus.valid = 1'b1;
    assign bus.data_bus = counter;

endmodule

module stream_sink #(
    parameter int DATA_BUS_WIDTH = 8
) (stream_if.SINK bus, input logic reset, input logic stall, output logic [7:0] sum);

    assign bus.ready = ~stall;
    always_ff @(posedge bus.clk) begin
        if (reset)
            sum <= 8'h00;
        else if (bus.valid && bus.ready) 
            sum <= sum + bus.data_bus;
    end

endmodule

module top_module (
    input logic clk,
    input logic reset,
    input  logic stall,
    output logic [7:0] sum
);

    stream_if #(.DATA_BUS_WIDTH(8)) bus (.clk(clk));

    stream_source #(.DATA_BUS_WIDTH(8)) source (.bus(bus.SOURCE), .reset(reset));
    stream_sink #(.DATA_BUS_WIDTH(8)) sink (.bus(bus.SINK), .reset(reset), .stall(stall), .sum(sum));

endmodule