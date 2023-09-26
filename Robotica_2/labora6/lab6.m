% =========================================================================
% MT3006 - LABORATORIO 6
% -------------------------------------------------------------------------
% Emplee el código base que se presenta a continuación para implementar un
% filtro de Kalman discreto en el tiempo que le permita realizar fusión de
% sensores para un proceso LTI, según los pasos indicados en la guía.
% =========================================================================
% Se carga la data de los sensores a emplear dentro del filtro de Kalman
load('sensor_and_process_data.mat');

%% Inciso 2. Discretización de las matrices del proceso
Ac = [ 0.0401, -1.2664, -1.5875, -0.3849, -3.6640;
      -1.0401, -2.4291, -2.6959, -3.5142, -5.6597;
      -1.0695,  1.7028, -3.2403, -2.7309, -3.8982;
      -2.5963, -1.4495,  4.0520, -1.3531, -0.3330;
       1.0374, -2.1781,  2.3110,  0.5828, -0.2173 ];

Bc = [ 0; 0; 0; 0; 0]; 

Cc = [ 1, 0, 0, 0, 0; 
       0, 1, 0, 0, 0 ]; 

Fc = [ 0, 0; 
       0, 0; 
       0, 0; 
       1, 0; 
       0, 1 ];

dt = 0.01;

sys = ss(Ac, Fc, Cc, zeros(2,2));  
sys1d = c2d(sys,dt,'zoh');

A = sys1d.A;
B = Bc;
F = sys1d.B;
C = sys1d.C;
D = sys1d.D;

%% Inciso 3. Estimación de matrices de covarianza
[w, v] = sensor_test();

var_w = var(w.');
var_v = var(v.');

Qw = [var_w(1), 0;
      0, var_w(2)];

Qv = [var_v(1), 0;
      0, var_v(2)];



%% Inciso 4. Inicialización de variables para el filtro
xhat_prior = ones(length(A),1); 
xhat_post = ones(length(A),1);

P_prior = ones(5);
P_post = ones(5); 

% Array para almacenar el resultado del filtro de Kalman ***NO MODIFICAR***
XHAT = zeros(numel(xhat_post), length(Y)); 



%% Inciso 5. Implementación del filtro de Kalman
for k = 1:length(Y)
    
    y_k = Y(:,k);

    %Predicción
    xhat_prior = A*xhat_post + B;
    P_prior = A*P_post*A' + F*Qw*F';

    %Corrección
    L_k = (P_prior*C')*(Qv + C*P_prior*C')^(-1);
    xhat_post = xhat_prior + L_k*(y_k - C*xhat_prior);
    P_post = P_prior - (L_k*C*P_prior);
    
    % Se guarda la salida del filtro de Kalman ***NO MODIFICAR***
    XHAT(:,k) = xhat_post;
end



%% Generación de gráficas ***NO MODIFICAR***
figure('units', 'normalized', 'outerposition', [0 0 1 1]);
subplot(2,2,[1,3]);
plot(t, X', 'LineWidth', 1);
grid minor;
axis square;
try
    hold on;
    ax = gca;
    ax.ColorOrderIndex = 1;
    plot(t(2:end), XHAT', '--', 'LineWidth', 1.5);
    hold off;
catch
end
title('Variables de proceso (reales en sólido)');
xlabel('$t$','Interpreter','latex','FontSize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'FontSize', 16);


subplot(2,2,2);
plot(t(2:end), Y', 'LineWidth', 1);
grid minor;
title('Mediciones de los sensores (antes del filtro)');
xlabel('$t$','Interpreter','latex','FontSize', 16);
ylabel('$\mathbf{y}_\mathrm{noisy}(t)$', 'Interpreter', 'latex', 'FontSize', 16);

try
    subplot(2,2,4);
    plot(t(2:end), (C*XHAT)', 'LineWidth', 1);
    grid minor;
    title('Mediciones de los sensores (después del filtro)');
    xlabel('$t$','Interpreter','latex','FontSize', 16);
    ylabel('$\mathbf{y}_\mathrm{clean}(t)$', 'Interpreter', 'latex', 'FontSize', 16);
catch

end