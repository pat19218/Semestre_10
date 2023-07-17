%% IE3042 - Temas Especiales de Electr�nica y Mecatr�nica 2
%  Ayuda para la Hoja de Trabajo 1
%  Luis Alberto Rivera

% La funci�n rand genera n�meros aleatorios de una distribuci�n uniforme en
% el intervalo (0,1).
N = 100;
X = rand(N,1);    % vector columna con N n�meros aleatorios en (0,1)
Y = -1 + 3*rand(N,1);    % vector columna con N n�meros aleatorios en (-1,2)

% Graficar los puntos X sobre el eje x, y un punto adicional en otro color,
% relleno, y m�s grande
% Pueden investigar la funci�n scatter para ver m�s opciones
figure(1); clf;
scatter(X,zeros(N,1),'b');
hold on;
scatter(0.5,0,100,'r', 'filled');

% Graficar los puntos (X,Y) en el plano x-y, y un punto adicional en otro
% color, con otra forma, y m�s grande.
figure(2); clf;
scatter(X,Y,'gx');
hold on;
scatter(0.5,0.5,150,'kd', 'filled');
