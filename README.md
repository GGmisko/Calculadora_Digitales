# Calculadora Digital Combinacional — VHDL

Proyecto de diseño de sistemas digitales desarrollado para la **Pontificia Universidad Javeriana**, utilizando la tarjeta de desarrollo **Terasic DE0** y el lenguaje **VHDL**.

El sistema implementa una calculadora digital completamente combinacional para operandos de 4 bits, incluyendo operaciones aritméticas, validación BCD, conversión binario-BCD y diferentes modos de visualización.

## Descripción

La calculadora permite trabajar con dos operandos de 4 bits ingresados mediante los interruptores de la tarjeta DE0.

Las operaciones principales son:

* **Suma**
* **Resta**
* **Multiplicación**

La selección de operación se realiza mediante los interruptores `SW9-SW8`.

| SW9-SW8 | Operación                  |
| ------- | -------------------------- |
| `00`    | Suma                       |
| `01`    | Resta                      |
| `10`    | Multiplicación             |
| `11`    | Reservado / modo adicional |

Los operandos se introducen mediante los interruptores de la tarjeta y los resultados se visualizan utilizando los displays de 7 segmentos.

## Características

* Diseño completamente combinacional.
* Arquitectura jerárquica en VHDL.
* Operandos de 4 bits.
* Validación de entradas BCD.
* Suma en complemento a dos.
* Resta en complemento a dos.
* Multiplicador combinacional 4×4.
* Conversión de binario a BCD.
* Decodificación para displays de 7 segmentos.
* Multiplexación de las diferentes operaciones.
* Comparador de magnitud.
* Codificador de prioridad.
* Modos adicionales mediante los pulsadores de la tarjeta.
* Banco de pruebas para verificación del sistema.
* Implementación sobre la tarjeta Terasic DE0.

## Arquitectura del proyecto

El sistema está dividido en diferentes bloques funcionales:

```text
                 ┌──────────────────────┐
                 │   top_calculadora    │
                 └──────────┬───────────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
     ┌──────────┐      ┌──────────┐     ┌─────────────┐
     │   Suma   │      │  Resta   │     │ Multiplicador│
     │ adder_n  │      │add_sub_n │     │ multiplier4x4│
     └────┬─────┘      └────┬─────┘     └──────┬──────┘
          │                 │                  │
          └─────────────────┼──────────────────┘
                            ▼
                    ┌───────────────┐
                    │ mux_operaciones│
                    └───────┬───────┘
                            │
                ┌───────────┴───────────┐
                │                       │
                ▼                       ▼
         ┌────────────┐          ┌──────────────┐
         │ validador  │          │   bin2bcd    │
         │    BCD     │          │              │
         └────────────┘          └──────┬───────┘
                                        │
                                        ▼
                                 ┌────────────┐
                                 │ deco7seg   │
                                 └─────┬──────┘
                                       │
                                       ▼
                              Displays 7 segmentos
```

## Archivos principales

| Archivo                     | Función                                               |
| --------------------------- | ----------------------------------------------------- |
| `top_calculadora.vhd`       | Entidad de nivel superior e interconexión del sistema |
| `adder_n.vhd`               | Sumador parametrizable                                |
| `add_sub_n.vhd`             | Circuito de suma/resta                                |
| `multiplier4x4.vhd`         | Multiplicador combinacional 4×4                       |
| `mux_operaciones.vhd`       | Selección de la operación                             |
| `bin2bcd.vhd`               | Conversión de binario a BCD                           |
| `validador_bcd.vhd`         | Validación del rango BCD                              |
| `comparador_magnitud.vhd`   | Comparación entre operandos                           |
| `codificador_prioridad.vhd` | Prioridad de los modos mediante pulsadores            |
| `logica_modos.vhd`          | Control de los modos de visualización                 |
| `deco7seg.vhd`              | Decodificación para displays de 7 segmentos           |
| `tb_calculadora.vhd`        | Banco de pruebas del sistema                          |
| `top_calculadora.sdc`       | Restricciones de tiempo                               |
| `Proyecto1_Calculadora.qpf` | Archivo de proyecto de Quartus                        |
| `Proyecto1_Calculadora.qsf` | Configuración y asignación de pines de Quartus        |

## Modos de funcionamiento

### Modo normal

Permite realizar:

* Suma
* Resta
* Multiplicación

Los resultados se muestran en BCD utilizando los displays de 7 segmentos.

### Detección de error

Los operandos válidos se encuentran en el rango:

```text
0 ≤ A ≤ 9
0 ≤ B ≤ 9
```

Si alguno de los operandos está fuera del rango BCD permitido, el sistema indica una condición de error.

### Modo hexadecimal

El pulsador `BUTTON0` permite trabajar con el rango completo de 4 bits:

```text
0 – F
```

### Modo comparador

`BUTTON1` permite comparar los dos operandos y visualizar el mayor, además de indicar la relación entre ellos.

### Prueba de displays

`BUTTON2` activa la prueba de los displays de 7 segmentos.

Cuando se presionan varios pulsadores simultáneamente, se utiliza la prioridad:

```text
BUTTON2 > BUTTON1 > BUTTON0
```

## Hardware

**Tarjeta:** Terasic DE0

**Dispositivos utilizados:**

* Interruptores `SW`
* Pulsadores `BUTTON`
* LEDs verdes `LEDG`
* Displays de 7 segmentos

## Herramientas

* VHDL
* Intel/Altera Quartus II
* Terasic DE0
* ModelSim, para simulación

## Simulación

El archivo:

```text
tb_calculadora.vhd
```

contiene el banco de pruebas utilizado para verificar el funcionamiento del sistema.

La prueba busca comprobar las diferentes combinaciones de operandos y operaciones y comparar los resultados obtenidos con los resultados esperados.

## Compilación en Quartus

1. Abrir Quartus.
2. Seleccionar **File → Open Project**.
3. Abrir:

```text
Proyecto1_Calculadora.qpf
```

4. Verificar las asignaciones de pines de la tarjeta DE0.
5. Compilar el proyecto.
6. Programar la FPGA utilizando el archivo `.sof` generado.
7. Probar los diferentes modos mediante los interruptores y pulsadores.

## Estructura del repositorio

```text
.
├── *.vhd
├── top_calculadora.sdc
├── Proyecto1_Calculadora.qpf
├── Proyecto1_Calculadora.qsf
├── output_files/
│   └── Proyecto1_Calculadora.sof
├── README.md
└── .gitignore
```

Los directorios y archivos generados automáticamente por Quartus y ModelSim se excluyen mediante `.gitignore`.

## Objetivo académico

El proyecto busca aplicar conceptos de diseño de sistemas digitales, incluyendo circuitos combinacionales, diseño jerárquico en VHDL, circuitos aritméticos, multiplexores, conversores de código, comparadores y codificadores de prioridad.

## Autores

**José Robayo**
**Carolhina Real**
**Samuel Diaz**

Pontificia Universidad Javeriana
Ingeniería Mecatrónica
