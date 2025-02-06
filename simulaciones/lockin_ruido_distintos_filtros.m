%% Graficos lockin 
set(groot, 'defaultLegendInterpreter','latex');

% Datos para la funcion que calcula el lock-in
M=128;Numero_filtros=64;
N_realizaciones=100;
Tipo_filtro="IIR2"
SNR=[10,0,-10,-20];

% Eje X para los gráficos
N_filtro = 1:Numero_filtros;
w = 0.0125./N_filtro;

for iteracion = 1:4   
    subplot(2,2,iteracion);
    [std_amps,mean_amps,k,std_in] = LockIn (M, Numero_filtros ,SNR(iteracion),N_realizaciones,Tipo_filtro);
    
    if(Tipo_filtro == "MA")    
        plot(N_filtro,std_amps,'xk');grid on;
        hold on;plot(N_filtro, std_in * k ./ sqrt(N_filtro*M),'-k');
        title("SNR = " + SNR(iteracion) + " dB ");
        legend("Valores obtenidos","Ajuste a $\frac{\sigma_{i} k }{\sqrt{Bw}}$ con k= " + k );
        xlabel("N_{filtro}");ylabel("\sigma_{o}");  
    end
    
    if((Tipo_filtro == "IIR2")||(Tipo_filtro == "IIR1"))   
        plot(1./w,std_amps,'xk');grid on;
        hold on;plot(1./w, std_in * k .* sqrt(w));
        legend("Valores obtenidos","Ajuste a $\frac{\sigma_{i} k }{\sqrt{Bw}}$ con k= " + k );
        title("SNR = " + SNR(iteracion) + " dB ");
        xlabel("$\frac{1}{w_c}$",'Interpreter','Latex');ylabel("$\sigma_{o}$",'Interpreter','Latex');   
    end

end

% Imprimir la figura en escala de grises
publicationPrint6(gcf, 20, [], 'Simulaciones de ruido en Lockin', 'png');



