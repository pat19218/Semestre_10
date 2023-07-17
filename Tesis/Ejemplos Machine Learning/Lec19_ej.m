%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 19 - Ejercicio
%  Luis Alberto Rivera

%% Generación de muestras
% Entrenamiento
% mu11 = [1 3]'; mu12 = [-1 1.5]'; mu13 = [0 -0.2]'; mu14 = [4 0.5]';
% f = 0.2;
% Sig11 = f*[4 0;0 1]; Sig12 = f*[1 0;0 4]; Sig13 = f*[3 0;0 1]; Sig14 = f*[1 0;0 4];
% 
% mu21 = [4 2.5]'; mu22 = [1.5 1.5]'; mu23 = [2.5 -0.5]'; mu24 = [1.5 -2]';
% Sig21 = f*[2 0.5;0.5 1]; Sig22 = f*[3 0;0 1]; Sig23 = f*[1 0;0 4]; Sig24 = f*[3 0;0 1];
% 
% N = 30;
% X1_train = [mvnrnd(mu11,Sig11,N);mvnrnd(mu12,Sig12,N);mvnrnd(mu13,Sig13,N);mvnrnd(mu14,Sig14,N)];
% X2_train = [mvnrnd(mu21,Sig21,N);mvnrnd(mu22,Sig22,N);mvnrnd(mu23,Sig23,N);mvnrnd(mu24,Sig24,N)];
% X_train = [X1_train;X2_train];  % Todas las muestras de entrenamiento
% 
% % Prueba
% delta = 0.075; % Step size of the grid
% [x1Grid,x2Grid] = meshgrid(min(X_train(:,1)):delta:max(X_train(:,1)),...
%                            min(X_train(:,2)):delta:max(X_train(:,2)));
% X_test = [x1Grid(:),x2Grid(:)]; % reorganiza las muestras como vectores fila
% save L19_datos.mat X1_train X2_train X_test x1Grid x2Grid

load L19_datos.mat
N1 = size(X1_train,1);
N2 = size(X2_train,1);
X_train = [X1_train;X2_train];  % Todas las muestras de entrenamiento
Y = [ones(N1,1);-1*ones(N2,1)]; % Etiquetas

figure(7); clf;
gscatter(X_train(:,1),X_train(:,2),Y);
grid on;
title('Muestras de Entrenamiento');

%% Crear celdas y vectores para guardar modelos y otras cosas
ModeloSVM = cell(1,2);
ModeloVC = cell(1,2);
errorVC = zeros(1,2);
asignado = cell(1,2);
valores = cell(1,2);
titulos = {'Kernel Polinomial Grado 3','Kernel Gaussiano'};

ModeloSVM{1} = fitcsvm(X_train,Y,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',3);
ModeloSVM{2} = fitcsvm(X_train,Y,'KernelFunction','rbf','KernelScale','auto');

% Se hace validación cruzada con las muestras de entrenamiento, se calcula el error
% de clasificación de la validación cruzada, se clasifican las muestras de prueba,
% y se grafican resultados. Todo lo anterior para los 6 modelos de arriba.
for k = 1:2
    % Validación cruzada, clasificación errónea
    ModeloVC{k} = crossval(ModeloSVM{k});
    errorVC(k) = kfoldLoss(ModeloVC{k});
    
    % Clasificación de las muestras de prueba
    [asignado{k},valores{k}] = predict(ModeloSVM{k},X_test); % etiquetas asignadas, valores
    
    % Gráficas
    figure(k); clf;
    subplot(1,2,1);
    gscatter(X_train(:,1),X_train(:,2),Y); hold on;
    % Vectores de soporte
    plot(X_train(ModeloSVM{k}.IsSupportVector,1),X_train(ModeloSVM{k}.IsSupportVector,2),'ko','MarkerSize',10);
    % Frontera de decisión
    contour(x1Grid,x2Grid,reshape(valores{k}(:,2),size(x1Grid)),[0 0],'k');
    grid on;
    title('Muestras de Entrenamiento y Frontera de Decisión')
    legend({'-1','1','Support Vectors'},'Location','Best');
    
    subplot(1,2,2);
    gscatter(X_test(:,1),X_test(:,2),asignado{k});
    legend({'-1','1'},'Location','Best');
    grid on;
    title('Muestras de Prueba');
    sgtitle(sprintf('%s.    Error en la Validación Cruzada: %.2f%%',titulos{k},100*errorVC(k)));
end
