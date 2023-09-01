% =========================================================================
% MT3006 - LABORATORIO 5
% -------------------------------------------------------------------------
% Emplee el código base que se presenta a continuación para evaluar la 
% implementación de cada uno de los comportamientos reactivos que se le 
% solicitan en la guía del laboratorio. Modifique sólo en los lugares del
% código en donde se le indica.
% =========================================================================
caso = 3;       % 0 : Encarar a un objeto
                % 1 : Mantener una distancia fija hacia un objeto
                % 2 : Combinacion de los dos anteriores
                % 3 : Colocar al objeto en una posicion deseada
%% Parámetros del sistema
% Pose de la cámara con respecto de la base del robot
BR_C = [0,0,1; -1,0,0; 0,-1,0];
Bo_C = [0;0;0.1];
BT_C = [BR_C, Bo_C; 0,0,0,1];

% Parámetros intrínsecos y extrínsecos de la cámara
f = 0.015;
rhow = 1e-5;
rhoh = 1e-5;
fp = f/rhow;
u0 = 1024/2;
v0 = 1024/2;
Kcam = [fp,0,u0,0; 0,fp,v0,0; 0,0,1,0];
C = Kcam*BT_C^(-1);

%% Definición del sistema dinámico
% xi = [x; y; theta]  y  u = [v; omega]

% Campo vectorial del sistema dinámico
dyn = @(xi,mu) [mu(1)*cos(xi(3)); mu(1)*sin(xi(3)); mu(2)];

%% Parámetros de la simulación
dt = 0.01; % período de muestreo
t0 = 0; % tiempo inicial
tf = 20; % tiempo final
N = (tf-t0)/dt; % número de iteraciones

%% Inicialización y condiciones iniciales
% xi0 = [0; 0; pi/2+0.5]; % condición incial por defecto como backup
if caso == 0              % ***** PUEDE MODIFICAR *****
    xi0 = [-1; -1; pi/2+0.5];
elseif caso == 1
    xi0 = [0; 0; 3*pi/2];
elseif caso == 2
    xi0 = [0; 0; pi/2+0.5];
elseif caso == 3
    xi0 = [-2; -1; 3*pi/2+0.5];
else 
    xi0 = [0; 0; pi/2+0.5];
end

mu0 = [0; 0];
xi = xi0; % vector de estado 
mu = mu0; % vector de entradas

%% Parámetros para el visual servoing
% point0 = [0.5;2;0.2]; % punto por defecto como backup
% ***** PUEDE MODIFICAR *****
% centro del objeto de interés
if caso == 0             
    point = [0.5;2;0.2];
elseif caso == 1
    point = [0;-2;0.2];
elseif caso == 2
    point = [0;2;0.2];
elseif caso == 3
    point = [2;1;0.2];
else 
    point = [0.5;2;0.2];
end
% Inicialización de la visualización del plano de imagen
IR_B = [cos(xi(3)), -sin(xi(3)), 0; sin(xi(3)), cos(xi(3)), 0; 0,0,1];
Io_B = [xi(1:2); 0.05];
IT_B = [IR_B, Io_B; 0,0,0,1];    
ls = C*IT_B^(-1)*[point;1];
s = ls(1:2)/ls(3) - [u0;v0];

% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y trayectoria del punto de interés en el plano de imagen
XI = zeros(numel(xi),N+1);
MU = zeros(numel(mu),N+1);
S = zeros(numel(s),N+1);
% Inicialización de arrays
XI(:,1) = xi0;
MU(:,1) = mu0;
S(:,1) = s;


%% Solución recursiva del sistema dinámico
for n = 0:N
    % Pose del robot con respecto del marco inercial
    IR_B = [cos(xi(3)), -sin(xi(3)), 0; sin(xi(3)), cos(xi(3)), 0; 0,0,1];
    Io_B = [xi(1:2); 0.05];
    IT_B = [IR_B, Io_B; 0,0,0,1];
    
    % Proyección del punto de interés al plano de imagen
    ls = C*IT_B^(-1)*[point;1];
    s = ls(1:2)/ls(3) - [u0;v0]; % feature vector
    lambda = ls(3); % profundidad del objeto con respecto de la cámara
    
    % *********************************************************************
    % COLOCAR LOS COMPORTAMIENTOS AQUÍ
    % *********************************************************************
    
    if caso == 0
        v = 0.0;
        w = 0.001*(0-s(1));  

    elseif caso == 1
        v = 0.01*(100 + s(2));
        w = 0.00*(0 - s(1));  

    elseif caso == 2
        v = 0.01*(100 + s(2));
        w = 0.001*(0-s(1));  

    elseif caso == 3
        v =  0.01*(100 + s(2));
        w = 0.001*(100-s(1)); 
        
    else 
        v = 0.1;
        w = -0.2;
    end
    % *********************************************************************
    
    % Vector de entrada del sistema
    mu = [v;w];
    
    % Se actualiza el estado del sistema mediante una discretización por 
    % el método de Runge-Kutta (RK4)
    k1 = dyn(xi, mu);
    k2 = dyn(xi+(dt/2)*k1, mu);
    k3 = dyn(xi+(dt/2)*k2, mu);
    k4 = dyn(xi+dt*k3, mu);
    xi = xi + (dt/6)*(k1+2*k2+2*k3+k4);
    
    % Se guardan las trayectorias del estado y las entradas
    XI(:,n+1) = xi;
    MU(:,n+1) = mu;
    S(:,n+1) = s;
end


%% Animación y generación de figuras (NO modificar)
figure;
t = t0:dt:tf;
plot(t, XI', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$x(t)$', '$y(t)$', '$\theta(t)$', 'Location', 'best', ...
    'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
grid minor;

figure;
subplot(1,2,1);
% sf = max(max(abs(XI(1:2,:))));
sf = 2;
xlim(sf*[-1, 1]+[-0.5, 0.5]);
ylim(sf*[-1, 1]+[-0.5, 0.5]);
grid minor;
hold on;

q = XI(:,1);
x = q(1); y = q(2); theta = q(3);

scatter(point(1), point(2), 50, 'r', 'filled');
trajplot = plot(x, y, '--k', 'LineWidth', 1);

BV = [-0.1, 0, 0.1; 0, 0.3, 0];
IV = [cos(theta-pi/2), -sin(theta-pi/2); sin(theta-pi/2), cos(theta-pi/2)] * BV;
bodyplot = fill(IV(1,:) + x, IV(2,:) + y, [0.5,0.5,0.5]);

xlabel('$x$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$y$', 'Interpreter', 'latex', 'Fontsize', 16);
axis square;
hold off;

subplot(1,2,2);
camres = 1024/2;
line([0,0], 2*[-camres,camres], 'Color','k'); 
hold on;
line(2*[-camres,camres], [0,0], 'Color','k');
pttraj = plot(S(1,1), S(2,1), '--r', 'LineWidth', 1);
ptplot = scatter(S(1,1), S(2,1), 50, 'r', 'filled');
hold off;
xlim([-u0,u0]);
ylim([-v0,v0]);
grid minor;
axis square;

for n = 2:N+1
    q = XI(:,n);
    x = q(1); y = q(2); theta = q(3);
    
    trajplot.XData = [trajplot.XData, x];
    trajplot.YData = [trajplot.YData, y];
    
    BV = [-0.1, 0, 0.1; 0, 0.3, 0];
    IV = [cos(theta-pi/2), -sin(theta-pi/2); sin(theta-pi/2), cos(theta-pi/2)] * BV;
    bodyplot.XData = IV(1,:) + x;
    bodyplot.YData = IV(2,:) + y;
  
    pttraj.XData = [pttraj.XData, S(1,n)];
    pttraj.YData = [pttraj.YData, S(2,n)];
    ptplot.XData = S(1,n);
    ptplot.YData = S(2,n);
    
    pause(dt);
end