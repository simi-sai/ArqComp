`timescale 1ns / 1ps

`define ADD 6'b100000

module tb_TOP ();
    parameter DATA_WIDTH = 8;
    parameter OP_WIDTH = 6;

    reg clk, reset, select_a, select_b, select_op;
    reg [DATA_WIDTH-1:0] IN_DATA;
    wire [DATA_WIDTH-1:0] OUT_DATA;
    wire zero, negative, overflow;

    // Valores esperados
    reg [DATA_WIDTH-1:0] expected_result;
    reg expected_zero, expected_negative, expected_overflow;
    
    integer errors = 0;

    TOP #(DATA_WIDTH, OP_WIDTH) uut_top (
        .clk(clk), .reset(reset),
        .select_a(select_a), .select_b(select_b), .select_op(select_op),
        .IN_DATA(IN_DATA),
        .OUT_DATA(OUT_DATA),
        .zero(zero), .negative(negative), .overflow(overflow)
    );

    initial begin
        clk = 0;
        forever #4 clk = ~clk;
    end
    
    task check_results;
        input integer test;

        begin
            @(negedge clk); // Para asegurar que los registros se actualizaron
            if (OUT_DATA != expected_result || zero != expected_zero || negative != expected_negative || overflow != expected_overflow) begin
                $display("Test %0d failed", test);
                $display("Expected: OUT_DATA=%h, zero=%b, neg=%b, overflow=%b", expected_result, expected_zero, expected_negative, expected_overflow);
                $display("Got:      OUT_DATA=%h, zero=%b, neg=%b, overflow=%b", OUT_DATA, zero, negative, overflow);
                errors = errors + 1;
            end
            else begin
                $display("Test %0d passed: OUT_DATA=%h, zero=%b, neg=%b, overflow=%b", test, OUT_DATA, zero, negative, overflow);
            end
        end
    endtask

    initial begin
        reset = 0; select_a = 0; select_b = 0; select_op = 0; IN_DATA = 0;
        expected_result = 0; expected_zero = 1; expected_negative = 0; expected_overflow = 0;
        @(negedge clk);

        // Test 1: Reinicio de registros
        IN_DATA = 8'hAA;
        reset = 1; select_a = 0; select_b = 0; select_op = 0;
        @(posedge clk);
        
        @(negedge clk);
        expected_result = 0; expected_zero = 1; expected_negative = 0; expected_overflow = 0;
        check_results(1);

        // Test 2: A, B y ADD
        @(negedge clk);
        reset = 0;
        IN_DATA = 8'h20;
        select_a = 1; select_b = 0; select_op = 0;
        @(posedge clk);

        @(negedge clk);
        select_a = 0;
        IN_DATA = 8'h44;
        select_b = 1;
        @(posedge clk);

        @(negedge clk);
        select_b = 0;
        IN_DATA = `ADD;
        select_op = 1;
        @(posedge clk);

        @(negedge clk);
        select_op = 0;
        @(posedge clk);

        @(negedge clk);
        expected_result = 8'h64; // 0x20 + 0x44
        expected_zero = 0; expected_negative = 0; expected_overflow = 0;
        check_results(2);

        // Test 3: Retencion de valores (no se selecciona nada)
        @(negedge clk);
        IN_DATA = 8'hFF;
        select_a = 0; select_b = 0; select_op = 0;
        @(posedge clk);

        @(negedge clk);
        expected_result = 8'h64; // Debe mantenerse el resultado anterior
        expected_zero = 0; expected_negative = 0; expected_overflow = 0;
        check_results(3);

        // Test 4: Overflow (ADD: 0xFF + 0x01)
        @(negedge clk);
        reset = 0;
        select_a = 1; select_b = 0; select_op = 0;
        IN_DATA = 8'hFF;
        @(posedge clk);

        @(negedge clk);
        select_a = 0; select_b = 1;
        IN_DATA = 8'h01;
        @(posedge clk);

        @(negedge clk);
        select_b = 0; select_op = 1;
        IN_DATA = `ADD;
        @(posedge clk);

        @(negedge clk);
        select_op = 0;
        @(posedge clk);

        @(negedge clk);
        expected_result = 8'h00; // 0xFF + 0x01
        expected_zero = 1; expected_negative = 0; expected_overflow = 1;
        check_results(4);

        $display("Tests Completados");
        $display("Total de errores: %d", errors);
        $finish;
    end

endmodule