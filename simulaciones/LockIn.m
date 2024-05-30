function [std_amps,mean_amps,k,std_in] = LockIn (M, Numero_filtros ,SNR,Nrealizaciones,Tipo_filtro)
%% Definimos la señal de entrada:

% Puntos por ciclo de señal y cantidad de ciclos

% Cuantizacion de la señal: Bits del ADC
Qs=24;

% Señal de entrada f=fs/M -> w = (2)/M -> Si M=32 -> 0.125
n=0:1:M-1;
A_signal = (2^(Qs-1)-1);
Arms_signal = A_signal / sqrt(2);
sen = floor ( A_signal + A_signal*(sin(2*pi.*n/M)) );


% Relacion señal a ruido -> 
A_ruido = Arms_signal/ (10^(SNR/20));
std_in = A_ruido / sqrt(12);


%% Definimos la señal de referencia:
Qref=16;

% Onda sinusoidal:
ref_s_1 =floor ((2^(Qref-1)-1)*(sin(2*pi.*n/M)) );
ref_c_1 =floor ((2^(Qref-1)-1)*(cos(2*pi.*n/M)) );


%% Datos del filtro PB
Qfiltro = 30;
N_filtro = 1:Numero_filtros;


%% Computamos el lockin

Amp=zeros(length(N_filtro),Nrealizaciones);
phi=zeros(length(N_filtro),Nrealizaciones);

if((Tipo_filtro == "IIR2")||(Tipo_filtro == "IIR1"))
    w=zeros(length(N_filtro),1);    % Frecuencias de corte de los filtros IIR
end

for i = 1 : length(N_filtro)
    
    signal = (repmat(sen,1,i));
    ref_s = repmat(ref_s_1,1,i);
    ref_c = repmat(ref_c_1,1,i);
    
    % Definimos el filtro pasabajos a utilizar:
    
    if (Tipo_filtro == "MA")
        b = ones (1,M*N_filtro(i))/(M*N_filtro(i));
        B = 2^Qfiltro * b;
        A = 1;
        div = 2^Qfiltro;
    end
    if (Tipo_filtro == "IIR1")
        w(i) = 0.0125/N_filtro(i);
        [B,A] = butter(1,w(i));
        A=round(2^Qfiltro*A);
        B=round(2^Qfiltro*B);
        div=1;
    end
    if (Tipo_filtro == "IIR2")
        w(i) = 0.0125/N_filtro(i);
        [B,A] = butter(2,w(i));
        A=round(2^Qfiltro*A);
        B=round(2^Qfiltro*B);
        div=1;
    end        
    
        
   
    % Calculamos muchas realizaciones del lockin
    for realizacion=1:Nrealizaciones
        
        % Agregamos ruido a la señal:
        s = signal + floor ( A_ruido.* rand(1,M*i) );

        % Salida del multiplicador:
        data_out_sen = ref_s .* s;
        data_out_cos = ref_c .* s;

        % Salida del filtro pasabajos:
        salida_fase = filter(B,A,data_out_sen) / div;
        salida_cuad = filter(B,A,data_out_cos) / div;

        % Calculo de parámetros:
        Amp(i,realizacion) = sqrt (salida_fase(end).^2 + salida_cuad(end).^2 ) .* 2 ./ (2^Qref/2-1);
        phi(i,realizacion) = atan(salida_cuad(end)/salida_fase(end));    
        
    end
end
std_amps = std(Amp,0,2);
mean_amps = mean(Amp,2);

%% Ajuste de minimos cuadrados

if(Tipo_filtro == "MA")
    b = ((std_in./std_amps).^2);
    A_ajuste = transpose(N_filtro.*M);
    x = (transpose(A_ajuste)*A_ajuste)\ ((transpose(A_ajuste)) * b);
    k = sqrt(1/x);
end

% Si el filtro es IIR hay que cambiar un poco como se hace el ajuste
if((Tipo_filtro == "IIR2")||(Tipo_filtro == "IIR1"))
    
    b = ((std_amps./std_in).^2);
    A_ajuste = (w);
    x = (transpose(A_ajuste)*A_ajuste)\ ((transpose(A_ajuste)) * b);
    k = sqrt(x);
             
end


end
