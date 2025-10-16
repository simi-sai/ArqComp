`timescale 1ns / 1ps
`default_nettype none

module REG #(parameter DATA_WIDTH = 8) (
    input wire clk, reset, select,
    input wire [DATA_WIDTH-1:0] IN,
    output reg [DATA_WIDTH-1:0] OUT
);

    always @(posedge clk) begin
        if (reset) begin
            OUT <= {DATA_WIDTH{1'b0}};
        end
        else if(select) begin
            OUT <= IN;
        end
    end

endmodule
