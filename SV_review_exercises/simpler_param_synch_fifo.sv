//  Parameterizable synchronous FIFO with DATA_WIDTH bits and DEPTH entries (DEPTH
//  is a power of two). It has a single clock, a synchronous active-high reset, write enable 
//  wr_en, read enable rd_en, and flags full and empty. A write when full and a read when 
//  empty must be ignored. The read data rd_data must show the oldest element combinationally 
// (mem[rd_ptr]), so the data is available in the same cycle in which empty is low. Also 
//  provide an output count with the number of stored elements.

module sync_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH = 16
)
(
    input logic clk,
    input logic reset,
    input logic wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    input logic rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic full,
    output logic empty,
    output logic[$clog2(DEPTH):0] count
);
    localparam int AW = $clog2(DEPTH);

    logic [DATA_WIDTH-1:0] mem [DEPTH];
    logic [AW:0] wr_ptr, rd_ptr;   // one extra bit

    always_ff @(posedge clk) begin
        if (reset) begin
            wr_ptr <= 1'b0;
        end
        else begin
            if (wr_en && !full) begin
                wr_ptr <= wr_ptr + 1'b1;
                mem[wr_ptr[AW-1:0]] <= wr_data;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            rd_ptr <= 1'b0;
        end
        else begin
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

    assign full = ((rd_ptr[AW-1:0] == wr_ptr[AW-1:0]) && (rd_ptr[AW] != wr_ptr[AW]));
    assign empty = (rd_ptr == wr_ptr);
    assign count = wr_ptr - rd_ptr;

    assign rd_data = mem[rd_ptr[AW-1:0]];


endmodule