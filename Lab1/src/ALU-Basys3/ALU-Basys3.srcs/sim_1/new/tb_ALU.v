`timescale 1ns / 1ps

// Ocho operaciones
`define ADD 6'b100000
`define SUB 6'b100010
`define AND 6'b100100
`define OR  6'b100101
`define XOR 6'b100110
`define NOR 6'b100111
`define SRA 6'b000011
`define SRL 6'b000010

module tb_ALU ();
    // Parametros
    parameter DATA_WIDTH = 8;
    parameter OP_WIDTH = 6;

    reg [DATA_WIDTH-1:0] A, B;
    reg [OP_WIDTH-1:0] OP;
    reg [OP_WIDTH-1:0] OP_Array [7:0];
    wire [DATA_WIDTH-1:0] RESULT;
    wire ZERO, NEG, OVERFLOW;

    ALU #(DATA_WIDTH, OP_WIDTH) uut (
        .A(A), .B(B), .OP(OP),
        .result(RESULT),
        .zero(ZERO),
        .negative(NEG),
        .overflow(OVERFLOW)
    );

    integer n, errors = 0;
    reg [DATA_WIDTH-1:0] expected_result;
    reg expected_zero, expected_overflow, expected_negative;

    initial begin
        OP_Array[0] = `ADD;
        OP_Array[1] = `SUB;
        OP_Array[2] = `AND;
        OP_Array[3] = `OR;
        OP_Array[4] = `XOR;
        OP_Array[5] = `NOR;
        OP_Array[6] = `SRA;
        OP_Array[7] = `SRL;
    end

    task check_results;
        if (RESULT != expected_result || ZERO != expected_zero || NEG != expected_negative || OVERFLOW != expected_overflow) begin
            $display("Test failed for A=%h, B=%h, OP=%b", A, B, OP);
            $display("Expected: RESULT=%h, ZERO=%b, NEG=%b, OVERFLOW=%b", expected_result, expected_zero, expected_negative, expected_overflow);
            $display("Got:      RESULT=%h, ZERO=%b, NEG=%b, OVERFLOW=%b", RESULT, ZERO, NEG, OVERFLOW);
            errors = errors + 1;
        end 
        else begin
            $display("Test passed for A=%h, B=%h, OP=%b, n=%d", A, B, OP, n);
        end
    endtask
    
    initial begin
        A = 0; B = 0; OP = 0;

        #10;

        for (n = 0; n < 256; n = n + 1) begin
            A = $random;
            B = $random;
            OP = OP_Array[$urandom % 8];
            
            expected_overflow = 0;
            expected_negative = 0;

            #10;

            case(OP)
                `ADD: begin
                    expected_result = A + B;
                    expected_overflow = (A[DATA_WIDTH-1] == B[DATA_WIDTH-1]) && (expected_result[DATA_WIDTH-1] != A[DATA_WIDTH-1]);
                end
                `SUB: expected_result = A - B;
                `AND: expected_result = A & B;
                `OR:  expected_result = A | B;
                `XOR: expected_result = A ^ B;
                `NOR: expected_result = ~(A | B);
                `SRA: expected_result = $signed(A) >>> B;
                `SRL: expected_result = A >> B;
                default: expected_result = {DATA_WIDTH{1'b0}};
            endcase

            expected_zero = (expected_result == 0);
            expected_negative = expected_result[DATA_WIDTH-1] && (OP == `SUB || OP == `SRA);
            
            check_results;
        end

        $display ("TEST COMPLETADOS");
        $display ("TOTAL DE ERRORES: %d", errors);
        $finish;
    end

endmodule