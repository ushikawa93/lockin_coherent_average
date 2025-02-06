%% Algunas simulaciones para mostrar que LI con MAF (N ciclos) y CA (N_ciclos) + LI (1 ciclo) dan iguales resultados
clear all;close all;

N = 4;
M = 128;

n = 0:1:M*N-1;

% Señales de referencia:
A_ref = 1;
ref_s = A_ref*(sin(2*pi.*n/M)) ;
ref_c = A_ref*(cos(2*pi.*n/M)) ;

% Defino la señal de entrada
A_signal = 1;
offset = 0;

A_ruido = 1;
std_in = A_ruido / sqrt(12);

signal = offset + A_signal*(sin(2*pi.*n/M))  +  A_ruido.* rand(1,M*N) ; 

%% Lockin clasico:

producto_fase_li = signal .* ref_s ; 
producto_cuad_li = signal .* ref_c;

salida_fase_li = filter(ones(1,M*N),1,producto_fase_li) / (M*N);
salida_cuad_li = filter(ones(1,M*N),1,producto_cuad_li) / (M*N);


amplitud_estimada_li = sqrt (salida_fase_li.^2 + salida_cuad_li.^2 ) .* 2 ./ A_ref;
fase_estimada_li = atan(salida_cuad_li/salida_fase_li);    


A_li = amplitud_estimada_li(end);
Phi_li = fase_estimada_li(end);


%% Promedio coherente de N_ciclos + Lockin de 1 ciclo

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

A_ca_li = amplitud_estimada_ca_li(end);
Phi_ca_li = fase_estimada_ca_li(end);


%% Graficos

extra_cycles = 2;

graph_li = [amplitud_estimada_li, A_li *ones(1,extra_cycles*M)];
graph_ca_li = [zeros(1,M*N), amplitud_estimada_ca_li, A_ca_li * ones(1,(extra_cycles-1)*M)];

plot(graph_li,'-x');hold on;plot(graph_ca_li,'-o');
ylabel("Estimated signal's ampitude",'FontSize',30);
xlabel("Time[ticks]",'FontSize',30);
legend("Calculation with LI","Calculation with CA\_LI");set(legend,'fontsize',30,'Location','northwest');

text((N+1)*M+5,A_li-0.2,"Estimation: " + A_li,'fontsize',30);

grid on;



