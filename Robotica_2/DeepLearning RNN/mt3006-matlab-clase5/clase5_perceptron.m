% =========================================================================
% MT3006 - CLASE 5: EJEMPLO CLASIFICACIÓN BINARIA CON PERCEPTRÓN
% =========================================================================
% En el siguiente ejemplo se empleará un perceptrón para resolver un
% problema de clasificación binaria. El entrenamiento del perceptrón se 
% hará de forma "tonta", planteando y resolviendo directamente el problema 
% de optimización.
% =========================================================================
%% Creación y ploteo de data aleatoria en 2D
X0 = randn(2,100); % categoría 0
X1 = randn(2,100) + [2; 2]; % categoría 1

% Se hace un gráfico de dispersión de los datos
figure;
scatter(X0(1,:), X0(2,:), 'o', 'filled');
hold on;
scatter(X1(1,:), X1(2,:), 100, 'x', 'LineWidth', 1);
axis square;
grid minor;
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 14);

%% Entrenamiento
% Se generan las observaciones y labels
X = [X0, X1];
y = [zeros(1, size(X0,2)), ones(1, size(X1,2))];

% Se re-arregla la data aleatoriamente
idx = randperm(size(X, 2));
X = X(:, idx);
y = y(:, idx);

% Entrenamiento de forma "tonta" resolviendo directamente el problema de
% optimización de pérdida
w0 = ones(3,1);
objfun = @(w) loss_function(X, y, w);

w_opt = fmincon(objfun, w0, [], []); % Parámetros óptimos

%% Se grafica el modelo resultante
% Se grafica el plano/línea separadora, recordando que para un plano se
% cumple la ecuación ax+by+cz+d = 0
m = -w_opt(2) / w_opt(3);
b = -w_opt(1) / w_opt(3);
x1 = min(X(1,:)):0.1:max(X(1,:));
y1 = m*x1 + b;
plot(x1, y1, 'k', 'LineWidth', 1);
hold off;
syms x1;
legend('Categoría 0', 'Categoría 1', ['$x_2=', latex(vpa(m*x1+b,2)), '$'], ...
    'Interpreter', 'latex', 'location', 'southeast', 'FontSize', 12);