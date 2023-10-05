%% Corrido para generar las varianzas
load data_para_var.mat

%% Parametros
N_x = 256;    %flancos por revolucion (ticks)

distancia_l = 381;      %distancia entre ruedas (mm)
r = 195;    %radio de la rueda(mm)

%% Parámetros de la simulación
dt = 0.01; % período de muestreo
t0 = 0; % tiempo inicial
tf = 10; % tiempo final
N = (tf-t0)/dt; % número de iteraciones

delta_rticks = zeros(1,N+1); 
delta_lticks = zeros(1,N+1); 
Dl = zeros(1,N+1); 
Dr = zeros(1,N+1); 
Dc = zeros(1,N+1); 
d_theta = zeros(1,N+1); 

%% vector para encoders

for n = 2:N
    delta_rticks(:,n) = ENC_L(n) - ENC_L(n-1);
    delta_lticks(:,n) = ENC_R(n) - ENC_R(n-1);
    
    Dl = 2*pi*r*(delta_lticks/N_x);
    Dr = 2*pi*r*(delta_rticks/N_x);
    
    Dc = (Dr + Dl) / 2;     % cambio en desplazamiento lineal 
    d_theta = (Dr - Dl) / distancia_l;% cambio en desplazamiento angular
end

%% Varianzas

GPS = GPS';
d = [Dc', d_theta'];

var_GPS = var(GPS);
var_d = var(d);

Qw = [var_GPS(1), 0;
      0, var_GPS(2)];

Qv = [var_d(1), 0;
      0, var_d(2)];

%% Almacenamiento de varianzas
save ("varianzas_gps_enc.mat", "Qv", "Qw")



