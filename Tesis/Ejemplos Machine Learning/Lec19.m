%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 19
%  Luis Alberto Rivera

%% Generación de muestras de entrenamiento, tomado de la documentación de Matlab
rng(1);  % For reproducibility (con esto, cada vez se generan los mismos valores aleatorios)
n = 100; % Number of points per quadrant

r1 = sqrt(rand(2*n,1));                     % Random radii
t1 = [pi/2*rand(n,1); (pi/2*rand(n,1)+pi)]; % Random angles for Q1 and Q3
X1 = [r1.*cos(t1) r1.*sin(t1)];             % Polar-to-Cartesian conversion

r2 = sqrt(rand(2*n,1));
t2 = [pi/2*rand(n,1)+pi/2; (pi/2*rand(n,1)-pi/2)]; % Random angles for Q2 and Q4
X2 = [r2.*cos(t2) r2.*sin(t2)];

X = [X1; X2];        % Predictors
Y = ones(4*n,1);
Y(2*n + 1:end) = -1; % Labels

figure(7); clf;
gscatter(X(:,1),X(:,2),Y);
grid on;
title('Scatter Diagram of Simulated Data')

%% Generación de muestras de prueba
delta = 0.02; % Step size of the grid
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):delta:max(X(:,1)),min(X(:,2)):delta:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)]; % reorganiza las muestras como vectores fila

%% Crear celdas y vectores para guardar modelos y otras cosas
ModeloSVM = cell(1,6);
ModeloVC = cell(1,6);
errorVC = zeros(1,6);
asignado = cell(1,6);
valores = cell(1,6);
titulos = {'Kernel Lineal','Kernel Polinomial Grado 2','Kernel Polinomial Grado 3',...
           'Kernel Polinomial Grado 4','Kernel Gaussiano, Muestras No Estandarizadas',...
           'Kernel Gaussiano, Muestras Estandarizadas'};

%% Entrenamiento, variando Kernels y ciertos parámetros
ModeloSVM{1} = fitcsvm(X,Y,'KernelFunction','linear','KernelScale','auto');
ModeloSVM{2} = fitcsvm(X,Y,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',2);
ModeloSVM{3} = fitcsvm(X,Y,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',3);
ModeloSVM{4} = fitcsvm(X,Y,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',4);
ModeloSVM{5} = fitcsvm(X,Y,'KernelFunction','rbf','KernelScale','auto');
ModeloSVM{6} = fitcsvm(X,Y,'KernelFunction','rbf','KernelScale','auto','Standardize',true);

% Se hace validación cruzada con las muestras de entrenamiento, se calcula el error
% de clasificación de la validación cruzada, se clasifican las muestras de prueba,
% y se grafican resultados. Todo lo anterior para los 6 modelos de arriba.
for k = 1:6
    % Validación cruzada, clasificación errónea
    ModeloVC{k} = crossval(ModeloSVM{k});
    errorVC(k) = kfoldLoss(ModeloVC{k});
    
    % Clasificación de las muestras de prueba
    [asignado{k},valores{k}] = predict(ModeloSVM{k},xGrid); % etiquetas asignadas, valores
    
    % Gráficas
    figure(k); clf;
    subplot(1,2,1);
    gscatter(X(:,1),X(:,2),Y); hold on;
    % Vectores de soporte
    plot(X(ModeloSVM{k}.IsSupportVector,1),X(ModeloSVM{k}.IsSupportVector,2),'ko','MarkerSize',10);
    % Frontera de decisión
    contour(x1Grid,x2Grid,reshape(valores{k}(:,2),size(x1Grid)),[0 0],'k');
    grid on;
    title('Muestras de Entrenamiento y Frontera de Decisión')
    legend({'-1','1','Support Vectors'},'Location','Best');
    
    subplot(1,2,2);
    gscatter(xGrid(:,1),xGrid(:,2),asignado{k});
    legend({'-1','1'},'Location','Best');
    grid on;
    title('Muestras de Prueba');
    sgtitle(sprintf('%s.    Error en la Validación Cruzada: %.2f%%',titulos{k},100*errorVC(k)));
end

