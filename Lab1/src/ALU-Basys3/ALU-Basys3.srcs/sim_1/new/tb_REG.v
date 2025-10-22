`timescale 1ns / 1ps

module tb_REG ();
    parameter DATA_WIDTH = 8;
    parameter OP_WIDTH = 6;

    reg clk, reset, select;

    reg [DATA_WIDTH-1:0] IN_DATA;
    wire [DATA_WIDTH-1:0] OUT_DATA;

    reg [OP_WIDTH-1:0] IN_OP;
    wire [OP_WIDTH-1:0] OUT_OP;

    reg [DATA_WIDTH-1:0] expected_data;
    reg [OP_WIDTH-1:0] expected_op;
    
    integer i, errors = 0;

    REG #(DATA_WIDTH) uut_data (
        .clk(clk),
        .reset(reset),
        .select(select),
        .IN(IN_DATA),
        .OUT(OUT_DATA)
    );

    REG #(OP_WIDTH) uut_op (
        .clk(clk),
        .reset(reset),
        .select(select),
        .IN(IN_OP),
        .OUT(OUT_OP)
    );

    initial begin
        clk = 0;
        forever #4 clk = ~clk;
    end

    task check_results;
        input integer cycle;

        begin @(negedge clk);
            if (OUT_DATA !== expected_data || OUT_OP !== expected_op) begin
                $display("DATA: Expected OUT=%b, Got OUT=%b", expected_data, OUT_DATA);
                $display("OP:   Expected OUT=%b, Got OUT=%b", expected_op, OUT_OP);
                errors = errors + 1;
            end
            else begin
                $display("Test %0d passed: OUT_DATA=%b, OUT_OP=%b", cycle, OUT_DATA, OUT_OP);
                $display("DATA: Expected OUT=%b, Got OUT=%b", expected_data, OUT_DATA);
                $display("OP:   Expected OUT=%b, Got OUT=%b", expected_op, OUT_OP);
            end
        end
    endtask
    
    initial begin
        reset = 0; select = 0; IN_DATA = 0; IN_OP = 0;
        expected_data = 0; expected_op = 0;
        @(negedge clk); // Esperar un ciclo de reloj

        // Test 1: Reset
        reset = 1; select = 0;
        IN_DATA = 8'hAA; IN_OP = 6'b101010;
        @(posedge clk); // Reset on posedge
        expected_data = 0; expected_op = 0;
        check_results(1);

        // Test 2: Seleccion de Datos
        reset = 0; select = 1;
        IN_DATA = 8'h55; IN_OP = 6'b110011;
        @(posedge clk);
        expected_data = 8'h55; expected_op = 6'b110011;
        check_results(2);

        // Test 3: Select = 0 (retener valor anterior)
        select = 0;
        IN_DATA = 8'hFF; IN_OP = 6'b111111;
        @(posedge clk);
        expected_data = 8'h55; expected_op = 6'b110011;
        check_results(3);

        // Tests Aleatorios
        for (i = 4; i < 35; i = i + 1) begin
            reset = $urandom % 2;
            select = $urandom % 2;
            IN_DATA = $urandom;
            IN_OP = $urandom;

            @(posedge clk);

            if (reset) begin
                expected_data = 0; expected_op = 0;
            end 
            else if (select) begin
                expected_data = IN_DATA; expected_op = IN_OP;
            end
            
            check_results(i);
        end
    
        $display("Tests Completados");
        $display("Total de errores: %d", errors);
        $finish;
    end
    
endmodule