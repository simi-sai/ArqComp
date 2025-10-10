`timescale 1ns / 1ps

module TOP #(parameter DATA_WIDTH = 8, parameter OP_WIDTH = 6) (
    input wire clk, reset, select,
    input wire [DATA_WIDTH-1:0] IN_DATA,
    output wire [DATA_WIDTH-1:0] OUT_DATA,
    output wire zero, overflow
);

    wire [DATA_WIDTH-1:0] REG_A, REG_B, REG_OP;

    // Inicializacion de salidas
    assign result = {DATA_WIDTH{1'b0}};
    assign zero = 1'b0;
    assign overflow = 1'b0;

    // Registros Intermedios
    REG #(DATA_WIDTH) reg_a (
        .clk(clk),
        .reset(reset),
        .select(select),
        .IN(IN_DATA),
        .OUT(REG_A)
    );

    REG #(DATA_WIDTH) reg_b (
        .clk(clk),
        .reset(reset),
        .select(select),
        .IN(IN_DATA),
        .OUT(REG_B)
    );

    REG #(OP_WIDTH) reg_op (
        .clk(clk),
        .reset(reset),
        .select(select),
        .IN(IN_DATA[OP_WIDTH-1:0]),
        .OUT(REG_OP)
    );

    // ALU
    ALU #(DATA_WIDTH, OP_WIDTH) alu (
        .A(REG_A),
        .B(REG_B),
        .operation(REG_OP),
        .result(OUT_DATA),
        .zero(zero),
        .overflow(overflow)
    );

endmodule
