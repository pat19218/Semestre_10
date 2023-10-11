% =========================================================================
% MT3006 - LABORATORIO 8
% -------------------------------------------------------------------------
% Emplee el código base que se presenta a continuación para desarrollar un
% EKF que permita la construcción del mapa con los obstáculos/landmarks
% dados, según lo indicado en la guía del laboratorio. Modifique sólo en
% los lugares del código en donde se le indica.
% =========================================================================

%% Parámetros de la simulación
dt = 0.01; % período de muestreo
t0 = 0; % tiempo inicial
tf = 20; % tiempo final ***** PUEDE MODIFICAR ***** %init 20
N = (tf-t0)/dt; % número de iteraciones

%% Generación de landmarks 
obs = [-2.14,  2.90, -3.80, -2.13, 4.97, -0.38,  3.59, -1.39, 2.18, -1.97;
       -0.09, -2.64,  1.81,  2.99, 1.30, -4.56, -0.75,  0.08, 2.80,  4.46];

%% Inicialización y condiciones iniciales
% Condiciones iniciales 
x0 = 0; % ***** PUEDE MODIFICAR *****   %init 0
y0 = 0; % ***** PUEDE MODIFICAR *****   %init 0
theta0 = pi/2; % ***** PUEDE MODIFICAR *****   %init pi/2

xi0 = [x0; y0; theta0; 0; 0];
mu0 = [0; 0];
xi = xi0; % vector de estado 
mu = mu0; % vector de entradas

% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y trayectoria del punto de interés en el plano de imagen
XI = zeros(numel(xi),N+1);
MU = zeros(numel(mu),N+1);
% Inicialización de arrays
XI(:,1) = xi0;
MU(:,1) = mu0;

% Arrays auxiliares para dashboard de sensores
GPS = zeros(2, N+1); 
ENC_R = zeros(1,N+1); 
ENC_L = zeros(1,N+1); 

% Inicialización del mapa (array de landmarks encontrados)
map = zeros(2,10);

%% Solución recursiva del sistema dinámico
for n = 0:N
    % *********************************************************************
    % COLOCAR EL CONTROLADOR AQUÍ
    % *********************************************************************
    % Velocidades de las ruedas del robot
    phiR = 6;
    phiL = 4;
    
    % Vector de entrada del sistema
    mu = [phiR; phiL];
    % *********************************************************************
    
    % Se adelanta un paso en la simulación del robot diferencial y se
    % obtienen las mediciones otorgadas por los sensores a bordo
    [gps_position, encoder_rticks, encoder_lticks, xi] = ...
        differential_drive(xi, mu, dt);

    [range, bearing] = distance_sensor(xi, obs);
    
    % Posición y orientación real del robot
    x = xi(1); y = xi(2); theta = xi(3);
    
    % *********************************************************************
    % IMPLEMENTAR EL EKF PARA LA CONSTRUCCIÓN DEL MAPA AQUÍ
    % *********************************************************************
    
    
    
    % *********************************************************************
    
    % Se guardan las trayectorias del estado y las entradas
    XI(:,n+1) = xi;
    MU(:,n+1) = mu;
    
    % Se recolectan las mediciones de los sensores para desplegarlas en un
    % dashboard
    GPS(:,n+1) = gps_position;
    ENC_R(:,n+1) = encoder_rticks;
    ENC_L(:,n+1) = encoder_lticks;
end

% Trayectoria real del estado del robot
figure;
t = t0:dt:tf;
plot(t, XI(1:3,:)', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$x(t)$', '$y(t)$', '$\theta(t)$', 'Location', 'best', ...
    'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
grid minor;

% Factor de escala para el "mundo" del robot
sf = 5; 


%% Animación y generación de figuras (NO modificar)
figure;
subplot(2,2,1);
plot(t, GPS', 'LineWidth', 1);
title('GPS');
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$x(t)$', '$y(t)$', 'Location', 'best', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
grid minor;
subplot(2,2,2);
stairs(t, ENC_R', 'LineWidth', 1);
title('Encoder rueda derecha');
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 14);
grid minor;
subplot(2,2,3);
stairs(t, ENC_L', 'LineWidth', 1);
title('Encoder rueda izquierda');
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 14);
grid minor;

figure;
xlim(sf*[-1, 1]+[-0.5, 0.5]);
ylim(sf*[-1, 1]+[-0.5, 0.5]);
grid minor;
hold on;

q = XI(:,1);
x = q(1); y = q(2); theta = q(3);

obstacles = scatter(obs(1,:), obs(2,:), 'r', 'filled');
sensor_plot = gobjects(1,10);
for i = 1:length(obs)
    sensor_plot(i) = plot([xi(1),xi(1)], [xi(2),xi(2)], '--b', 'LineWidth', 1);
end
trajplot = plot(x, y, '--k', 'LineWidth', 1);

BV = [-0.1, 0, 0.1; 0, 0.3, 0];
IV = [cos(theta-pi/2), -sin(theta-pi/2); sin(theta-pi/2), cos(theta-pi/2)] * BV;
bodyplot = fill(IV(1,:) + x, IV(2,:) + y, [0.5,0.5,0.5]);

xlabel('$x$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$y$', 'Interpreter', 'latex', 'Fontsize', 16);
axis square;
hold off;

for n = 2:N+1
    q = XI(:,n);
    x = q(1); y = q(2); theta = q(3);
    
    for i = 1:length(obs)
        if(norm(obs(:,i) - q(1:2)) <= 2)
            sensor_plot(i).XData = [x, obs(1,i)];
            sensor_plot(i).YData = [y, obs(2,i)];
        else
            sensor_plot(i).XData = [x, x];
            sensor_plot(i).YData = [y, y];
        end
    end
    
    trajplot.XData = [trajplot.XData, x];
    trajplot.YData = [trajplot.YData, y];
    
    BV = [-0.1, 0, 0.1; 0, 0.3, 0];
    IV = [cos(theta-pi/2), -sin(theta-pi/2); sin(theta-pi/2), cos(theta-pi/2)] * BV;
    bodyplot.XData = IV(1,:) + x;
    bodyplot.YData = IV(2,:) + y;
    
    pause(dt);
end