`timescale 1ns / 1ps

module multi_compuerta
(   // 4 I - 2 O
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire e,
    output wire f
);

    wire AB = a & b;
    wire CD = c & d;
    wire ABC = AB | c;
    
    assign e = ~ABC | CD;
    assign f = CD & d & c;
    
endmodule
