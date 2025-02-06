# Simulaciones Lock-in
Esta carpeta tiene tres scripts de Matlab para probar el algoritmo Lock-in.
Los archivos Lock-in.m y publicationPrint6.m son funciones auxiliares que utilizan los scripts.

## lockin_ruido_distintos_filtros.m: 
Permite probar el Lock-in con distintos filtros: media movil e iir de 1 o 2 polos, con distintos tiempos de integración.
De esta manera se puede estimar como afecta el ruido a los cálculos finales del Lock-in.

## lockin_simulaciones_li_ca.m
Permite comprobar la equivalencia entre los algoritmos CALI y LI.

## lockin_simulaciones_li_ca_Nrealizaciones.m
Igual que el script anterior pero con N realizaciones del proceso. Esto permite calcular estadísticas de cada algoritmo.

