%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Ayuda para la Hoja de Trabajo 1
%  Luis Alberto Rivera

% La función rand genera números aleatorios de una distribución uniforme en
% el intervalo (0,1).
N = 100;
X = rand(N,1);    % vector columna con N números aleatorios en (0,1)
Y = -1 + 3*rand(N,1);    % vector columna con N números aleatorios en (-1,2)

% Graficar los puntos X sobre el eje x, y un punto adicional en otro color,
% relleno, y más grande
% Pueden investigar la función scatter para ver más opciones
figure(1); clf;
scatter(X,zeros(N,1),'b');
hold on;
scatter(0.5,0,100,'r', 'filled');

% Graficar los puntos (X,Y) en el plano x-y, y un punto adicional en otro
% color, con otra forma, y más grande.
figure(2); clf;
scatter(X,Y,'gx');
hold on;
scatter(0.5,0.5,150,'kd', 'filled');
