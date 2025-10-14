`timescale 1ns / 1ps

module TOP #(parameter DATA_WIDTH = 8, parameter OP_WIDTH = 6) (
    input wire clk, reset,
    input wire select_a, select_b, select_op,
    input wire [DATA_WIDTH-1:0] IN_DATA,
    output wire [DATA_WIDTH-1:0] OUT_DATA
);

    wire [DATA_WIDTH-1:0] REG_A, REG_B;
    wire [OP_WIDTH-1:0] REG_OP;
    
    // Registros Intermedios
    REG #(DATA_WIDTH) reg_a (
        .clk(clk),
        .reset(reset),
        .select(select_a),
        .IN(IN_DATA),
        .OUT(REG_A)
    );

    REG #(DATA_WIDTH) reg_b (
        .clk(clk),
        .reset(reset),
        .select(select_b),
        .IN(IN_DATA),
        .OUT(REG_B)
    );

    REG #(OP_WIDTH) reg_op (
        .clk(clk),
        .reset(reset),
        .select(select_op),
        .IN(IN_DATA[OP_WIDTH-1:0]),
        .OUT(REG_OP)
    );

    // ALU
    ALU #(DATA_WIDTH, OP_WIDTH) alu_a (
        .A(REG_A),
        .B(REG_B),
        .operation(REG_OP),
        .result(OUT_DATA)
    );

endmodule
