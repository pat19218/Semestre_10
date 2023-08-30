% =========================================================================
% MT3006 - CLASE 8: GENERADOR DE RUIDO BLANCO Y SU EFECTO SOBRE UNA SEÑAL
% =========================================================================
% En el siguiente ejemplo se empleará la función randn de MATLAB para
% generar una instancia de un proceso estocástico de ruido blanco y luego
% se añadirá a una señal para ver su efecto.
% =========================================================================
mu = 0;
sigma = 0.5;

% Se especifica el vector de tiempo y la señal a añadirle el ruido
t = 0:0.01:10;
x = 2*cos(2*pi*1*t);

figure;
subplot(3,1,1);
plot(t, x, 'k', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 14);

% Se genera el ruido blanco y se añade, muestra por muestra, a la señal
% original
w = zeros(size(t)); % para visualizar sólo el ruido
y = zeros(size(t)); % para guardar la señal más el ruido

for i = 1:length(t)
    noise = sigma*randn + mu;
    w(i) = noise;
    y(i) = x(i) + noise;
end

% Se visualizan las señales restantes
subplot(3,1,2);
plot(t, w, 'k', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 14);
subplot(3,1,3);
plot(t, y, 'k', 'LineWidth', 1);
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 14);