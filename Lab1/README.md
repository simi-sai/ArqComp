# Lab 1: Arithmetic Logic Unit (ALU)

## Objetivos

- [ ] Implementar en FPGA una ALU.
- [X] La ALU debe ser parametrizable (bus de datos) para poder ser utilizada posteriormente en el trabajo final.
- [ ] Validar el desarrollo por medio de Testbench.
  - [ ] El testbench debe incluir generacion de entradas aleatorias y codigo de checkeo automatico.
- [ ] Simular el disenio usando herramientas de simulacion de VIVADO incluyendo Analisis de Tiempo.

## Consignas

### Operaciones a Implementar

La ALU debe implementar las siguientes operaciones:

<div align="center">

| Operacion | Codigo | Decripcion |
|-----------|--------|------------|
| ADD | 100000 | Suma |
| SUB | 100010 | Resta |
| AND | 100100 | AND lógica |
| OR  | 100101 | OR lógica |
| XOR | 100110 | XOR lógica |
| SRA | 000011 | Shift Right Arithmetic |
| SRL | 000010 | Shift Right Logical |
| NOR | 100111 | NOR lógica |

</div>

### Schematics

<div align="center">
    <img src="images/alu_schematic.png" alt="ALU Schematic" width="600"/>
</div>

## Desarrollo

### Implementacion de la ALU ([`ALU.v`](./src/ALU-Basys3/ALU-Basys3.srcs/sources_1/new/ALU.v))

Una ALU es un componente fundamental en los sistemas digitales que realiza operaciones aritméticas y lógicas en datos binarios. La implementación de una ALU en FPGA permite una gran flexibilidad y personalización en el diseño de sistemas digitales.

#### Parametrización del Bus de Datos

Para hacer la ALU parametrizable, se utilizan *parámetros de modulo* predefinidos, estos delimitan el ancho del bus de datos, permitiendo que la implementación de la ALU pueda ser utilizada con diferentes tamaños de datos sin necesidad de modificar el código fuente, pero permitiendo tambien un caso base. Para cambiar el ancho del bus de datos simplemente se debe modificar el valor del parametro `DATA_WIDTH` al instanciar el modulo. 

El resto de la implementacion de la ALU se adapta automaticamente al nuevo ancho del bus de datos.

>[!NOTE]
>El valor del parametro `OP_WIDTH`, si bien es parametrizable, no debe ser modificado, ya que esta directamente relacionado con la definicion de las operaciones y el selector del multiplexor.

**Declaracion del Modulo ALU parametrizable:**

```Verilog
module ALU #(parameter DATA_WIDTH = 8, parameter OP_WIDTH = 6) (
    input wire [DATA_WIDTH-1:0] A,
    input wire [DATA_WIDTH-1:0] B,
    input wire [OP_WIDTH-1:0] OP,
    output reg [DATA_WIDTH-1:0] result,
    output reg zero, overflow, negative
);

// ... Resto del codigo de la ALU ...

endmodule
```

#### Operaciones y Flags de Estado

La ALU implementa las siguientes operaciones:

- `ADD`: Suma de dos operandos.
- `SUB`: Resta de dos operandos.
- `AND`: Operación AND lógica.
- `OR`: Operación OR lógica.
- `XOR`: Operación XOR lógica.
- `SRA`: Desplazamiento a la derecha aritmético.
- `SRL`: Desplazamiento a la derecha lógico.
- `NOR`: Operación NOR lógica.

Las mismas se seleccionan mediante un multiplexor controlado por el valor registrado en el bus de operador (`OP`). Y se implementan utilizando una estructura `case` dentro de un bloque `always`. 

Tambien incluye tres flags de estado que proporcionan información adicional sobre el resultado de las operaciones: `zero`, `overflow` y `negative`.

- `zero`: Indica si el resultado de la operación es cero.
- `overflow`: Indica si ha ocurrido un desbordamiento en operaciones aritméticas.
- `negative`: Indica si el resultado de la operación es negativo.

**Implementacion de las Operaciones y Flags:**

```Verilog
/// ... Declaracion del Modulo ...

reg [DATA_WIDTH:0] aux_result; // Bit extra para detectar overflow

    always @(*) begin
        overflow = 0;

        case (OP)
            `ADD: begin
                aux_result = A + B;
                result = aux_result[DATA_WIDTH-1:0];
                overflow = aux_result[DATA_WIDTH];
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
        negative = result[DATA_WIDTH-1] & (OP == `SUB | OP == `SRA);
    end

/// ... Resto del codigo de la ALU ...
```

#### Schematics de ALU

Luego de realizar la implementacion de la ALU, se puede observar el siguiente esquema del circuito sintetizado:

<div align="center">
    <img src="images/implementacion_alu.png" alt="Esquema de ALU Sintetizada" width="600"/>
</div>

>[!NOTE]
>El esquema presentado es una representación simplificada y visual de la ALU, el cual no refleja realmente su implementacion interna, si observamos el esquema sintetizado real este muestra combinaciones de bloques LUTs y CARRY, que es la forma en que se implementan las operaciones aritméticas y lógicas en FPGAs.

### Registros Intermedios ([`REG.v`](./src/ALU-Basys3/ALU-Basys3.srcs/sources_1/new/REG.v))

Para implementar la logica previa al ingreso de datos a la ALU, se utilizan registros intermedios que almacenan temporalmente los datos de entrada ingresados (por medio de los switches) actuando como buffers. Estos registros permiten que los datos sean procesados de manera eficiente y sincrónica, asegurando que la ALU reciba los valores correctos en el momento adecuado.

Para la carga y limpieza de estos registros, se utilizan botones que actúan como señales de control. Contamos con un boton para cada registro (`select_a`, `select_c` y `select_op`) y un boton de reset (`reset`). Los mismos se encuentran dentro del modulo superior (`TOP.v`) y permiten cargar los datos desde los switches a los registros intermedios o limpiar su contenido.

**Implementacion de Registros Intermedios:**

```Verilog
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
```

**Schematics de Registros Intermedios:**

<div align="center">
    <img src="images/implementacion_registros.png" alt="Esquema de Registro Intermedio" width="600"/>
</div>

### Modulo Superior ([`TOP.v`](./src/ALU-Basys3/ALU-Basys3.srcs/sources_1/new/TOP.v))

El modulo superior (`TOP.v`) integra la ALU y los registros intermedios, gestionando la interaccion con los switches, botones de la FPGA y salida a LEDs. Este modulo se encarga de instanciar el resto de los modulos, coordinar la carga de datos en los registros, la seleccion de operaciones y la visualizacion de resultados.

**Implementacion del Modulo Superior:**

```Verilog
module TOP #(parameter DATA_WIDTH = 8, parameter OP_WIDTH = 6) (
    input wire clk, reset,
    input wire select_a, select_b, select_op,
    input wire [DATA_WIDTH-1:0] IN_DATA,
    output wire [DATA_WIDTH-1:0] OUT_DATA,
    output wire zero, overflow, negative
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
        .OP(REG_OP),
        .result(OUT_DATA),
        .zero(zero),
        .overflow(overflow),
        .negative(negative)
    );

endmodule
```

**Schematics del Modulo Superior:**

<div align="center">
    <img src="images/implementacion_completa.png" alt="Esquema de Modulo Superior" width="600"/>
</div>

### Constraints ([`Basys-3-Master.xdc`](./src/ALU-Basys3/ALU-Basys3.srcs/constrs_1/new/Basys-3-Master.xdc))

El archivo de constraints (`.xdc`) define las conexiones entre los pines de la FPGA y los componentes externos, como switches, botones y LEDs. Asegurando que las señales de entrada y salida estén correctamente mapeadas para el funcionamiento del diseño.

**Distribucion de Placa Basys 3:**

<div align="center">
    <img src="images/basys3-front.jpg" alt="Distribucion de Placa Basys 3" width="500"/>
</div>

Partiendo del archivo base proporcionado por Diligent, se realizaron unas modificaciones para adaptar las conexiones a los requerimientos del proyecto.

**Archivo de Constraints Modificado:**

```python
## Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports clk]

## Switches
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[0]}]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[1]}]
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[2]}]
set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[3]}]
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[4]}]
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[5]}]
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[6]}]
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {IN_DATA[7]}]

## LEDs
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {OUT_DATA[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {OUT_DATA[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {OUT_DATA[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {OUT_DATA[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {OUT_DATA[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {OUT_DATA[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {OUT_DATA[6]}]
# ... (5 LEDs no utilizados) ...
set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports negative]
set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports overflow]
set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports zero]

## Buttons
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports reset]
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports select_a]
set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports select_b]
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports select_op]
```

**Tabla de Asignacion de Pines:**

<div align="center">

| Señal | Pin/Pines (LSB-MSB)  | Descripcion |
|-------|------------|-------------|
| clk   | W5         | Señal de reloj principal (100MHz) |
| IN_DATA[7:0] | V17, V16, W16, W17, W15, V15, W14, W13 | Switches para entrada de datos y operacion |
| OUT_DATA[7:0] | U16, E19, U19, V19, W18, U15, U14 | LEDs para mostrar el resultado de la ALU |
| zero  | L1         | LED que indica si el resultado es cero |
| overflow | P1         | LED que indica si hay desbordamiento |
| negative | N3         | LED que indica si el resultado es negativo |
| reset | U18        | Boton para resetear los registros intermedios |
| select_a | W19        | Boton para cargar el valor del switch al registro A |
| select_b | T17        | Boton para cargar el valor del switch al registro B |
| select_op | U17        | Boton para cargar el valor del switch al registro OP |

</div>

### Testbenches

>[!NOTE]
>Completar

### Simulacion y Analisis de Tiempo

>[!NOTE]
>Completar

## Conclusiones

>[!NOTE]
>Completar
