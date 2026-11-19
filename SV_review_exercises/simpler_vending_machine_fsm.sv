// Mealy FSM for a vending machine that sells one product for 15 cents. It accepts only 
// nickels (5 cents) and dimes (10 cents), never both in the same cycle. 
// The output dispense must go high in the same cycle in which the coin that completes 
// (or exceeds) 15 cents is inserted. After dispensing, the machine returns to the initial 
// state. No change is given back. Use an enumerated type and a synchronous active-high 
// reset.

module vending_mealy (
    input logic nickel;
    input logic dimes;
    input logic clk;
    input logic reset;
    output logic dispense
);

    typedef enum logic[1:0] {
        S_0,
        S_05,
        S_10
    } state_t;

    state_t pr_state, nx_state;

    always_ff @(posedge clk) begin
        if (reset)
            pr_state <= S_0;
        else
            pr_state <= nx_state;
    end

    always_comb begin
        dispense   = 1'b0;    // default: no output (avoids latches)
        unique case (pr_state)
            S_0: begin
                dispense = 0;
                if (nickel)
                    nx_state = S_05;
                else if (dimes)
                    nx_state = S_10;
                else
                    nx_state = S_0;
            end
            S_05: begin
                if (nickel) begin
                    nx_state = S_10;
                    dispense = 0;
                end
                else if (dimes) begin
                    nx_state = S_0;
                    dispense = 1;
                end
                else begin
                    nx_state = S_05;
                    dispense = 0;
                end
            end
            S_10: begin
                if (nickel) begin
                    nx_state = S_0;
                    dispense = 1;
                end
                else if (dimes) begin
                    nx_state = S_0;
                    dispense = 1;
                end
                else begin
                    nx_state = S_10;
                    dispense = 0;
                end
            end
        endcase
    end

endmodule