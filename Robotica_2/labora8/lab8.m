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
tf = 40; % tiempo final * PUEDE MODIFICAR *
N = (tf-t0)/dt; % número de iteraciones
R_R = 0.032;
ell=96/2000; R= R_R/2;
encoder_lticks_past = 0;
encoder_rticks_past = 0;

%% Generación de landmarks 
obs = [-2.14,  2.90, -3.80, -2.13, 4.97, -0.38,  3.59, -1.39, 2.18, -1.97;
       -0.09, -2.64,  1.81,  2.99, 1.30, -4.56, -0.75,  0.08, 2.80,  4.46];

%% Inicialización y condiciones iniciales
% Condiciones iniciales 
x0 = 0; % * PUEDE MODIFICAR *
y0 = 0; % * PUEDE MODIFICAR *
theta0 = pi/2; % * PUEDE MODIFICAR *

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

t = 0:dt:tf;
t = size(t);
t = t(2);


%% Trayectoria a seguir en la exploración
x_traj = [-1.4,-3.5,-1.5,2,2.5,3.6,4,0,-0.5,-1.8];
y_traj = [1,0,-3.5,-2.5,0,2.5,4,4,3,1.2];
% traj_tf = spline(x_traj,y_traj);
% x_ax = linspace(-5,5,100);

x_size = 1:length(x_traj);
x_sizes = 1:0.1:length(x_traj);
x_path = spline(x_size,x_traj,x_sizes);
y_path = spline(x_size,y_traj,x_sizes);

%% PID Robot
% PID de orientacion
kpO = 5;
kiO = 0.0001;
kdO = 0;
EO = 0;
eO_1 = 0;

% Acercamiento exponencial
v0 = 1;
alpha = 0.9;
mark = 1;
L = 381/2000;
r_rueda = 195/2000;


v_x = 0.3601;
v_y = 0.0038;
% w_rho = 1.5507e-05;
% w_theta = 1.5507-05;
w_rho = 3e-05*10;
w_theta = 3e-05*10;

Qvg = [v_x, 0; 0, v_y]; % covarianzas que corresponden a las mediciones de posicion y bearing
Qw = [w_rho, 0; 0, w_theta]; % covarianzas que corresponden al ruido
% de proceso (encoders)
% v_x = 0.1519;
% v_y = 0.1653;
% w_rho = 3.2269e-04;
% w_theta = 3.4439e-04;
% 
% Qv = [v_x, 0; 0, v_y];
% Qw = [w_rho, 0; 0, w_theta];
x_prior = [];
x_post = zeros(20,1);

I = eye(3);
std_e = 0.5;
P_prior = 0.001*eye(4); P_post = P_prior;
% Array para almacenar el resultado del filtro de Kalman NO MODIFICAR
XHAT = zeros(3, N+1);
% plot(xq,yqs,'--', 'LineWidth', 1)
% plot(xq1,yqs1,'--', 'LineWidth', 1)
% plot(trajx,trajy,'--', 'LineWidth', 2)


k = 1; test = 2;
x = x0; y = y0; theta = theta0;
cant = 0; cant_1 = 0; new = 0;
z_k = zeros(20,1);


%% Solución recursiva del sistema dinámico
for n = 0:N
    % *********************************************************************
    % COLOCAR EL CONTROLADOR AQUÍ
    % *********************************************************************
    e = [x_path(mark)-xi(1);y_path(mark)-xi(2)];
    thetag = atan2(e(2),e(1));
    
    eP = norm(e);
    eO = thetag - xi(3);
    eO = atan2(sin(eO),cos(eO));
    
    if (eP < 0.95)
        if (mark < length(x_path))
            mark = mark + 1;
        end
    end
    
    kP = v0 * (1-exp(-alpha*eP^2)) / eP;
    v = kP*eP;
    
    %Control de velocidad angular
    eO_D = eO - eO_1;
    EO = EO + eO;
    w = kpO*eO + kiO*EO + kdO*eO_D;
    eO_1 = eO;
    
    % Velocidades de las ruedas del robot
    phiR = (v+w*L)/r_rueda;
    phiL = (v-w*L)/r_rueda;
    
% Vector de entrada del sistema
mu = [phiR; phiL];
% *********

% Se adelanta un paso en la simulación del robot diferencial y se
% obtienen las mediciones otorgadas por los sensores a bordo
[gps_position, encoder_rticks, encoder_lticks, xi] = ...
    differential_drive(xi, mu, dt);
[range, bearing] = distance_sensor(xi, obs);

% Posición y orientación real del robot
x = xi(1); y = xi(2); theta = xi(3);    

% *********
% IMPLEMENTAR EL EKF PARA LA CONSTRUCCIÓN DEL MAPA AQUÍ
% *********
%         N_ticks = 256;
%     delta_lticks = encoder_lticks - encoder_lticks_past;
%     delta_rticks = encoder_rticks - encoder_rticks_past;
%     DL = (2*pi*(0.195/2))*(delta_lticks)/(N_ticks);
%     DR = (2*pi*(0.195/2))*(delta_rticks)/(N_ticks);
%     d_rho = (DR+DL)/2; % desplazamiento lineal
%     d_theta = (DR-DL)/(0.391); % desplazamiento angular

cant = length(range);
g=@(i)  [x + range(i)*cos(theta+bearing(i));
         y + range(i)*sin(theta+bearing(i))];
H = @(x_prior,i,xi)[norm(x_prior(2*i-1)-xi(1),x_prior(2*i)-xi(2));
                atan2((x_prior(2*i)-xi(2)),x_prior(2*i-1)-xi(1))-xi(3)];
y_i = @(i)[range(i);
        bearing(i)];
C_i = @(x_prior,i,xi)[-(x_prior(2*i-1)-xi(1))/norm((x_prior(2*i-1)-xi(1)),(x_prior(2*i)-xi(2)))...
    -(x_prior(2*i)-xi(2))/norm((x_prior(2*i-1)-xi(1)),(x_prior(2*i)-xi(2)));
    (x_prior(2*i)-xi(2))/norm((x_prior(2*i-1)-xi(1)),(x_prior(2*i)-xi(2)))...
    -(x_prior(2*i-1)-xi(1))/norm((x_prior(2*i-1)-xi(1)),(x_prior(2*i)-xi(2)))];

if((isempty(x_prior)) && (length(range)==1))
    x_prior = g(1);
    %P_prior = 0.00031*eye(4);
end

for i=1:cant
    g_i = g(i);
    for j=1:(length(x_prior)/2)
        x_test = abs(g_i(1)-x_prior(2*j-1));
        y_test = abs(g_i(2)-x_prior(2*j));
        if((x_test<0.6) && (y_test<0.6))
            new = 0; marker = j;
            break
        end
        new = 1;
    end
    if(new)
        x_prior = vertcat(x_prior,g_i);
         Gy = [cos(theta + bearing(i)) -range(i)*sin(theta+bearing(i));
             sin(theta + bearing(i)) range(i)*cos(theta+bearing(i))];
         Yy = [eye(length(x_prior)) zeros(length(x_prior),2);...
             zeros(2,length(x_prior)) Qvg];
         P_prior = Yy*[P_post zeros(length(x_prior),2);...
             zeros(2,length(x_prior)) Qvg]*Yy';

%             C(i,:,:) = [];
    end
    new = 0; n_x = length(x_prior);
    z_k(2*marker-1:2*marker) = [y_i(i)-H(x_prior,marker,xi)];
     C(2*marker-1:2*marker,2*marker-1:2*marker)=C_i(x_prior,marker,xi);

end
if(test<x_prior)

  L_k = P_prior(1:n_x,1:n_x)*C(1:n_x,1:n_x)'/(C(1:n_x,1:n_x)*P_prior(1:n_x,1:n_x)...
      *C(1:n_x,1:n_x)'+kron(eye(n_x/2),Qvg2));
%     
  x_post = x_prior + L_k(1:n_x,1:n_x)*z_k(1:n_x);
  %P_post = P_prior;
  P_post(1:n_x,1:n_x) = P_prior(1:n_x,1:n_x)-L_k*C(1:n_x,1:n_x)*P_prior(1:n_x,1:n_x);
else
    P_post = P_prior;
end
      %x_post = x_prior; 


%     n = length(range);

%     A = eye(n);
%     B = zeros(n,n);
%     F = zeros(n,n);


%Yy = 
%P_prior = A*P_post*A'+F*Qw*F';

% *********

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
%% Mapa real vs Mapa generado
obs_prior = zeros(2,length(x_post)/2);
obs_post = zeros(2,length(x_post)/2);
for i=1:length(x_prior)/2
    obs_prior(:,i)=x_prior(2*i-1:2*i);
    obs_post(:,i)=x_post(2*i-1:2*i);
end
figure;
scatter(obs(1,:),obs(2,:),'r')
hold on
scatter(obs_prior(1,:),obs_prior(2,:),'g');
grid minor;

l = legend('$Medido$','$Real$', 'Location', 'best', ...
    'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 10);
xlabel('$x$', 'Interpreter', 'latex', 'Fontsize', 10);
ylabel('$y$', 'Interpreter', 'latex', 'Fontsize', 10);
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