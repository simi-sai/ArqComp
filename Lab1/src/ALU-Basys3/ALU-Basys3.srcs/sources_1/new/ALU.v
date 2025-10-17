`timescale 1ns / 1ps
`default_nettype none

`define ADD 6'b100000
`define SUB 6'b100010
`define AND 6'b100100
`define OR  6'b100101
`define XOR 6'b100110
`define NOR 6'b100111
`define SRA 6'b000011
`define SRL 6'b000010

module ALU #(parameter DATA_WIDTH = 8, parameter OP_WIDTH = 6) (
    input wire [DATA_WIDTH-1:0] A,
    input wire [DATA_WIDTH-1:0] B,
    input wire [OP_WIDTH-1:0] OP,
    output reg [DATA_WIDTH-1:0] result,
    output reg zero, overflow, negative
);

    always @(*) begin
        overflow = 0;
        
        case (OP)
            `ADD: begin
                result = A + B;
                overflow = (A[DATA_WIDTH-1] == B[DATA_WIDTH-1]) && (result[DATA_WIDTH-1] != A[DATA_WIDTH-1]);
            end
            `SUB: result = A - B;
            `AND: result = A & B;
            `OR:  result = A | B;
            `XOR: result = A ^ B;
            `NOR: result = ~(A | B);
            `SRA: result = $signed(A) >>> B;
            `SRL: result = A >> B;
            default: result = {DATA_WIDTH{1'b0}};
        endcase

        zero = (result == 0);
        negative = result[DATA_WIDTH-1] && (OP == `SUB | OP == `SRA);
    end

endmodule
