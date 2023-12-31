% =========================================================================
% MT3006 - LABORATORIO 7
% -------------------------------------------------------------------------
% Emplee el c�digo base que se presenta a continuaci�n para desarrollar un
% EKF que permita estimar el estado de un robot m�vil diferencial equipado
% con encoders incrementales en sus ruedas y un GPS, seg�n lo indicado en
% la gu�a del laboratorio. Modifique s�lo en los lugares del
% c�digo en donde se le indica.
% =========================================================================

%% Par�metros de la simulaci�n
dt = 0.01; % per�odo de muestreo
t0 = 0; % tiempo inicial
tf = 10; % tiempo final
N = (tf-t0)/dt; % n�mero de iteraciones

%% Inicializaci�n y condiciones iniciales
% Condiciones iniciales 
x0 = 0; % ***** PUEDE MODIFICAR ***** init 0
y0 = 0; % ***** PUEDE MODIFICAR ***** init 0
theta0 = pi/2; % ***** PUEDE MODIFICAR ***** init pi/2

xi0 = [x0; y0; theta0; 0; 0];
mu0 = [0; 0];
xi = xi0; % vector de estado 
mu = mu0; % vector de entradas

% Arrays para almacenar las trayectorias de las variables de estado,
% entradas y trayectoria del punto de inter�s en el plano de imagen
XI = zeros(numel(xi),N+1);
MU = zeros(numel(mu),N+1);
% Inicializaci�n de arrays
XI(:,1) = xi0;
MU(:,1) = mu0;

% Arrays auxiliares para dashboard de sensores
GPS = zeros(2, N+1); 
ENC_R = zeros(1,N+1); 
ENC_L = zeros(1,N+1); 

%% ************************************************************************ 
% variables robot movil    -(CP)-
%**************************************************************************
N_x = 256;    %flancos por revolucion (ticks)

encoder_lticks_prev = 0;
encoder_rticks_prev = 0;

distancia_l = 381/1000; %distancia entre ruedas (m)
r = 195/2000;           %radio de la rueda (m)

load("varianzas_gps_enc.mat")
%----------------------------------------------------------------------
% Discretizaci�n de las matrices del proceso
%----------------------------------------------------------------------
A_k = @(x3,u1,w1) ([1, 0, -(u1+w1)*sin(x3);...
                  0, 1, -(u1+w1)*cos(x3);...
                  0, 0, 1]);

B = @(x3) ([cos(x3), 0;...
           sin(x3), 0;...
           0, 1;]);

F_k = @(x3) ([cos(x3),0;...
              sin(x3),0;...
              0,1]);

C = [1, 0, 0;...
     0, 1, 0;];

D = zeros(2);

%funcion del sistema no lineal F(x,u,w) 
f = @(x,u,w)([x(1) + (u(1)+w(1))*cos(x(3));...
              x(2) + (u(1)+w(1))*sin(x(3));...
              x(3) +  u(2)+w(2)]);
%----------------------------------------------------------------------
% Inicializaci�n de variables para el filtro (EKF)
%----------------------------------------------------------------------
xhat_prior = [x0;y0;theta0]; %% inializaci�n variables del EKF
xhat_post = [x0;y0;theta0];
XHAT = [];

P_prior = 0.3*ones(3);
P_post = 0.3*ones(3); 

%**************************************************************************

%% Soluci�n recursiva del sistema din�mico
for n = 0:N
    % *********************************************************************
    % COLOCAR EL CONTROLADOR AQU�
    % *********************************************************************
    % Velocidades de las ruedas del robot
    if n < (N/2)+100
        phiR = 5;
        phiL = 4;
    else
        phiR = 2;
        phiL = 5;
    end
    
    % Vector de entrada del sistema
    mu = [phiR; phiL];

    % *********************************************************************
    
    % Se adelanta un paso en la simulaci�n del robot diferencial y se
    % obtienen las mediciones otorgadas por los sensores a bordo
    [gps_position, encoder_rticks, encoder_lticks, xi] = ...
        differential_drive(xi, mu, dt);
    
    % *********************************************************************
    % ESTIMAR EL ESTADO DEL ROBOT AQU�
    % *********************************************************************
    delta_rticks = encoder_rticks - encoder_rticks_prev;
    delta_lticks = encoder_lticks - encoder_lticks_prev;
    
    Dl = 2*pi*r*(delta_lticks/N_x);
    Dr = 2*pi*r*(delta_rticks/N_x);

    Dp = (Dr + Dl) / 2;     % cambio en desplazamiento lineal (u1)
    d_theta = (Dr - Dl) / distancia_l;%cambio en desplazamiento angular(u2)
    
    A = A_k(xhat_post(3),Dp,0);
    F = F_k(xhat_post(3));    

    encoder_lticks_prev = encoder_lticks;
    encoder_rticks_prev = encoder_rticks;

    

    %----------------------------------------------------------------------
    % Implementaci�n del filtro de Kalman
    %----------------------------------------------------------------------
    % prediccion 
    xhat_prior = f(xhat_post,[Dp,d_theta],[0,0]);
    P_prior = A*P_post*A' + F*Qw*F';
    
    % correcci�n
    yk = gps_position;
    Lk = P_prior*C'*(Qv+C*P_prior*C')^-1;
    xhat_post = xhat_prior + Lk*(yk-C*xhat_prior);
    P_post = P_prior - Lk*C*P_prior;
    
    % actualizaci�n
    xhat_prior = xhat_post;
    P_prior = P_post;
    trickR_k = encoder_rticks;
    trickL_k = encoder_lticks;
    % Se guarda la salida del filtro de Kalman ***NO MODIFICAR***
    XHAT(:,end+1) = xhat_post;
    

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

%Descomentar la siguiente linea si es la primera corrida
%save("data_para_var.mat", "ENC_L", "ENC_R", "GPS")

% Trayectoria real del estado del robot
% ***** MODIFICAR PARA GRAFICAR ENCIMA EL ESTADO ESTIMADO *****
figure;
t = t0:dt:tf;
plot(t, XI(1:3,:)', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{x}(t)$', 'Interpreter', 'latex', 'Fontsize', 16);
l = legend('$x(t)$', '$y(t)$', '$\theta(t)$', 'Location', 'best', ...
    'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
grid minor;
hold on;
plot(t,XHAT(1:3,:)','--', 'LineWidth', 1);
hold off;

% Factor de escala para el "mundo" del robot
sf = 6; %***** PUEDE MODIFICAR *****


%% Animaci�n y generaci�n de figuras (NO modificar)
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
    
    trajplot.XData = [trajplot.XData, x];
    trajplot.YData = [trajplot.YData, y];
    
    BV = [-0.1, 0, 0.1; 0, 0.3, 0];
    IV = [cos(theta-pi/2), -sin(theta-pi/2); sin(theta-pi/2), cos(theta-pi/2)] * BV;
    bodyplot.XData = IV(1,:) + x;
    bodyplot.YData = IV(2,:) + y;
    
    pause(dt);
end