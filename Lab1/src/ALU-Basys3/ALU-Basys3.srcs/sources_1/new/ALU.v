`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)

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
    input wire [OP_WIDTH-1:0] operation,
    output reg [DATA_WIDTH-1:0] result
);

    always @(*) begin
        case (operation)
            `ADD: result = A + B;
            `SUB: result = A - B;
            `AND: result = A & B;
            `OR:  result = A | B;
            `XOR: result = A ^ B;
            `NOR: result = ~(A | B);
            `SRA: result = $signed(A) >>> B;
            `SRL: result = A >> B;
            default: result = {DATA_WIDTH{1'b0}};
        endcase
    end

endmodule
