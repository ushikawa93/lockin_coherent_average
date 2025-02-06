# Repositorio con distintos recursos para probar el algoritmo CA_LI

## Proyecto coherent_average_tb
Lockin con y sin promediacion coherente en FPGA de Altera

Procesa los datos generados en el modulo data_source (onda sinusoidal generada mediante una Look-up table)
Lo hace con dos algoritmos distintos, demostrando que se obtienen los mismos resultados:
 
1) LI: Lock-in con filtro de media movil (MAF) de N_ma x N_ca ciclos de señal.
2) CA_LI: Promediación coherente de N_ca ciclos seguido de Lock-in con MAF de N_ma ciclos.

Funciona con una simulación o con hardware en la placa de1SoC.

### Simulación
Simulación con ModelSim, con un testbench provisto en el diseño

### Placa de1SoC
Operación en hardware. Para esta tenemos:
SW[8] -> Inicia la operación 
SW[0] -> Determina que resultados se muestran en los Display de 7 segmentos (0 CA_LI y 1 LI)
KEY[0] _> Reinicia la Operación

### Parametros configurables:
N_ca -> Cantidad de ciclos de promediación coherente
N_ma -> Cantidad de ciclos de Lockin con MAF
Q_signal -> Bits de cuantización de las señales de entrada del Lock-in (equivalente a N de bits del ADC que se utilize en operación normal)



## Proyectos fetch_test, multiplicador y sumador

Modulos para probar el timing de las distintas operaciones que deben realizarse para el Lock-in y Promediación coherente.
Todos los algoritmos probados para DE1SoC (cyclone V)


## Carpeta simulaciones
Simulaciones en Matlab para demostrar la equivalencia entra LI y CA_LI y el efecto del Lock-in sobre el ruido.

### Lockin_simulaciones.m 
Simula los algoritmos y grafica la evolución de las variables en el tiempo

### Lockin_simulaciones_Nrealizaciones.m 
Toma N realizaciones de los cálculos y determina estadísticas sobre la amplitud de los resultados

