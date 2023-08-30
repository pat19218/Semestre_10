% =========================================================================
% MT3006 - CLASE 8: DISPERSIÓN DE DATOS CON DISTRIBUCIÓN NORMAL
% =========================================================================
% En el siguiente ejemplo se generarán datos que corresponden a dos
% variables aleatorias (no correlacionadas) con distribución normal y se
% observarán sus dispersiones en el plano con el fin de evaluar qué ocurre
% al cambiar las medias y las varianzas.
% =========================================================================
% Media y desviación estándar (sqrt(varianza)) de las variables aleatorias
mu_x = 5;
sigma_x = 0.1;

mu_y = 2;
sigma_y = 2;

% Se generan los valores de las variables aleatorias
X = sigma_x * randn(1000, 1) + mu_x;
Y = sigma_y * randn(1000, 1) + mu_y;

% Se visualiza la dispersión de datos
figure;
scatter(X, Y,  'filled', 'MarkerFaceColor', [0.5, 0.5, 0.5], ...
    'MarkerEdgeColor', [0.5, 0.5, 0.5]);
hold on;
scatter(mu_x, mu_y, 100, 'k', 'filled');
xlim([floor(min(X)), ceil(max(X))]);
ylim([floor(min(Y)), ceil(max(Y))]);

% Desviación estándar en forma de elipse
th = linspace(0,2*pi) ; 
xe = mu_x + sigma_x * cos(th); 
ye = mu_y + sigma_y * sin(th);
plot(xe, ye, 'k', 'LineWidth', 1);