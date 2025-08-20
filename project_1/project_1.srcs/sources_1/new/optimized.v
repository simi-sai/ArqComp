`timescale 1ns / 1ps

module multi_compuerta_optimized
(
    input wire a, b, c, d,
    output wire e, f
);
    
    assign e = ~((a & b) | c) | (c & d);
    assign f = (c & d) & c & d;
    
endmodule
