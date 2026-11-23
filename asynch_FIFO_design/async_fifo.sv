// Parameterizable asynchronous FIFO with DATA_WIDTH bits and DEPTH entries 
// (DEPTH is a power of two, at least 4). The write side runs on wr_clk and 
// the read side on rd_clk, and the two clocks are unrelated. Each side has 
// its own active-low asynchronous reset (wr_rst_n, rd_rst_n), which you may 
// assume has already been synchronized to its own domain

module async_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH = 16
)
(
    input logic wr_clk,
    input logic wr_rst_n,
    input logic rd_clk,
    input logic rd_rst_n,
    input logic wr_en,
    input logic [DATA_WIDTH - 1: 0] wr_data,
    input logic rd_en,
    output logic [DATA_WIDTH - 1: 0] rd_data,
    output logic full,
    output logic empty
);

    localparam int AW = $clog2(DEPTH);

    logic [DATA_WIDTH - 1: 0] mem[DEPTH];

    logic [AW:0] wr_bin, wr_gray;
    logic [AW:0] wr_gray_synch1, wr_gray_synch2;
    logic [AW:0] rd_bin, rd_gray;
    logic [AW:0] rd_gray_synch1, rd_gray_synch2;


    function automatic [AW:0] logic bintogray([AW:0] logic bin_value);
        return bin_value ^ (bin_value >> 1);
    endfunction

    // Write_pointer and writing
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n)
            wr_bin <= 1'b0;
        else begin
            if(wr_en && !full) begin
                wr_bin <= wr_bin + 1'b1;
                wr_gray = bintogray(wr_bin + 1'b1);
            end
        end 
    end

    always_ff @(posedge wr_clk) begin
            if(wr_en && !full)
                mem[wr_bin[AW-1:0]] <= wr_data;
        end 
    end


    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_gray_synch1 <= 1'b0;
            wr_gray_synch2 <= 1'b0;
        end
        else begin
            wr_gray_synch1 <= wr_gray;
            wr_gray_synch2 <= wr_gray_synch1;
        end
    end

    // Reading pointer 
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n)
            rd_bin <= 1'b0;
        else begin
            if(rd_en && !empty) begin
                rd_bin <= rd_bin + 1'b1;
                rd_gray = bintogray(rd_bin + 1'b1); // As it is going to another clk domain, it need to be registered first
                                                    // If it would be combinational, glitches could not be solved before the 
                                                    // second clk assertion.
            end
        end 
    end 

    always_ff @(posedge wr_clk or negedge !wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_gray_synch1 <= 1'b0;
            rd_gray_synch2 <= 1'b0;
        end
        else begin
            rd_gray_synch1 <= rd_gray;
            rd_gray_synch2 <= rd_gray_synch1;
        end
    end

    // Read data
    assign rd_data = mem[rd_bin[AW-1:0]];

    assign empty = (wr_gray_synch2 == rd_gray);
    assign full = (wr_gray == {~rd_gray_synch2[AW:AW-1], rd_gray_synch2[AW-2:0]});

endmodule