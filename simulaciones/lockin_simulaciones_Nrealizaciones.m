%% Algunas simulaciones para mostrar que LI con MAF (N ciclos) y CA (N_ciclos) + LI (1 ciclo) dan iguales resultados 
% Seria igual al otro script pero con muchas realizaciones y sin graficos
clear all;close all;

N = 1024;
M = 128;
N_realizaciones = 100;

n = 0:1:M*N-1;

% Señales de referencia:
A_ref = 1;
ref_s = A_ref*(sin(2*pi.*n/M)) ;
ref_c = A_ref*(cos(2*pi.*n/M)) ;

% Defino la señal de entrada
A_signal = 1;
offset = 0;

A_ruido = 10;
std_in = A_ruido / sqrt(12);

A_li = zeros(N_realizaciones,1);
A_ca_li = zeros(N_realizaciones,1);

for k=1:N_realizaciones

    signal = offset + A_signal*(sin(2*pi.*n/M))  +  A_ruido.* rand(1,M*N) ; 

    % Lockin clasico:

    producto_fase_li = signal .* ref_s ; 
    producto_cuad_li = signal .* ref_c;

    salida_fase_li = filter(ones(1,M*N),1,producto_fase_li) / (M*N);
    salida_cuad_li = filter(ones(1,M*N),1,producto_cuad_li) / (M*N);


    amplitud_estimada_li = sqrt (salida_fase_li.^2 + salida_cuad_li.^2 ) .* 2 ./ A_ref;
    fase_estimada_li = atan(salida_cuad_li/salida_fase_li);    


    A_li(k) = amplitud_estimada_li(end);
    Phi_li = fase_estimada_li(end);


    % Promedio coherente de N_ciclos + Lockin de 1 ciclo

    signal_prom = zeros(1,M);

    for i=1:M

        for j=0:N-1

        signal_prom(i) = signal_prom(i) + signal(i+j*M);

        end
    end

    signal_prom = signal_prom ./ N;

    producto_fase_ca_li = signal_prom .* ref_s (1:M); 
    producto_cuad_ca_li = signal_prom .* ref_c (1:M);

    salida_fase_ca_li = filter(ones(1,M),1,producto_fase_ca_li) / (M);
    salida_cuad_ca_li = filter(ones(1,M),1,producto_cuad_ca_li) / (M);

    amplitud_estimada_ca_li = sqrt(salida_fase_ca_li.^2 + salida_cuad_ca_li.^2 ) .* 2 ./ A_ref;
    fase_estimada_ca_li =atan(salida_cuad_ca_li/salida_fase_ca_li);    

    A_ca_li(k) = amplitud_estimada_ca_li(end);
    Phi_ca_li = fase_estimada_ca_li(end);

end

% Resultados

std_amps_li = std(A_li,0,1);
mean_amps_li = mean(A_li,1);

std_amps_ca_li = std(A_ca_li,0,1);
mean_amps_ca_li = mean(A_ca_li,1);

fprintf("N: " +  N + "\n");
fprintf("Sigma_o esperado: " + std_in/(sqrt((N*M)/2) ) + "\n" );

fprintf("Amplitud (LI): " + mean_amps_li + "\n");
fprintf("Sigma_o (LI): " + std_amps_li + "\n");

fprintf("Amplitud (CA_LI): " + mean_amps_ca_li + "\n");
fprintf("Sigma_o (CA_LI): " + std_amps_ca_li + "\n\n");



