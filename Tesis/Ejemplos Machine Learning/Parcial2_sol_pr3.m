%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Segundo Parcial, Problema 3 - Solución
%  Luis Alberto Rivera

load Parcial2_pr3.mat
Ntrain1 = size(Xtrain1,1); Ntrain2 = size(Xtrain2,1);
Ntest1 = size(Xtest1,1); Ntest2 = size(Xtest2,1);

% Debemos aumentar todas las muestras, y "normalizar" las muestras de la clase 2
Ytrain = [[ones(Ntrain1,1),Xtrain1];-[ones(Ntrain2,1),Xtrain2]];
Ytest1 = [ones(Ntest1,1),Xtest1];
Ytest2 = -1*[ones(Ntest2,1),Xtest2];

%% --- inciso a ---
eta = 0.01; th = 1e-7; kmax = 500;
[a3_a, k] = batch_perceptron(Ytrain', eta, th, kmax, 0);  % a = [w0 w']'

%% --- inciso b ---
% Clase 1
clasif_c1_b = a3_a'*Ytest1';
correctos_c1_b = sum(clasif_c1_b > 0); % # de muestras de la clase 1 correctamente clasif.
incorrectos_c1_b = Ntest1 - correctos_c1_b; % # de muestras incorrectamente clasif.

% Clase 2
clasif_c2_b = a3_a'*Ytest2';
correctos_c2_b = sum(clasif_c2_b > 0); % # de muestras de la clase 2 correctamente clasif.
incorrectos_c2_b = Ntest2 - correctos_c2_b; % # de muestras incorrectamente clasif.

porcentaje_b = 100*(correctos_c1_b+correctos_c2_b)/(Ntest1+Ntest2); % clasif. correcta

%% --- inciso c ---
b3 = ones(Ntrain1+Ntrain2,1);   % Vector de márgenes
PseudoI = (Ytrain'*Ytrain)\Ytrain';
a3_c = PseudoI*b3;  % a = [w0 w']'

%% --- inciso d ---
clasif_c1_d = a3_c'*Ytest1';
correctos_c1_d = sum(clasif_c1_d > 0); % # de muestras de la clase 1 correctamente clasif.
incorrectos_c1_d = Ntest1 - correctos_c1_d; % # de muestras incorrectamente clasif.

clasif_c2_d = a3_c'*Ytest2';
correctos_c2_d = sum(clasif_c2_d > 0); % # de muestras de la clase 2 correctamente clasif.
incorrectos_c2_d = Ntest2 - correctos_c2_d; % # de muestras incorrectamente clasif.

porcentaje_d = 100*(correctos_c1_d+correctos_c2_d)/(Ntest1+Ntest2); % clasif. correcta

%% --- inciso e (extra) ---
syms x1 x2 x3
x = [x1;x2;x3];

% Sólo se pedía graficar las muestras de entrenamiento y la frontera, pero muestro
% también las muestras de prueba, con colores distintos.

% parte a
g3_a = a3_a(1) + a3_a(2:4)'*x;  % w0 + w1*x1 + w2*x2 + w3*x3
figure(1); clf;
scatter3(Xtrain1(:,1),Xtrain1(:,2),Xtrain1(:,3),'b','filled');
hold on;
scatter3(Xtrain2(:,1),Xtrain2(:,2),Xtrain2(:,3),'r','filled');
scatter3(Xtest1(:,1),Xtest1(:,2),Xtest1(:,3),'c','filled');
scatter3(Xtest2(:,1),Xtest2(:,2),Xtest2(:,3),'m','filled');
fimplicit3(g3_a,[-1 1.5 -2 4 -1 1]);
xlabel('x'); ylabel('y'); zlabel('z');
legend('C1 Train','C2 Train','C1 Test','C2 Test','frontera');
title('Problema 3, Extra. Usando Batch Perceptron');

% parte c
g3_c = a3_c(1) + a3_c(2:4)'*x;  % w0 + w1*x1 + w2*x2 + w3*x3
figure(2); clf;
scatter3(Xtrain1(:,1),Xtrain1(:,2),Xtrain1(:,3),'b','filled');
hold on;
scatter3(Xtrain2(:,1),Xtrain2(:,2),Xtrain2(:,3),'r','filled');
scatter3(Xtest1(:,1),Xtest1(:,2),Xtest1(:,3),'c','filled');
scatter3(Xtest2(:,1),Xtest2(:,2),Xtest2(:,3),'m','filled');
fimplicit3(g3_c,[-1 1.5 -2 4 -1 1]);
xlabel('x'); ylabel('y'); zlabel('z');
grid on;
legend('C1 Train','C2 Train','C1 Test','C2 Test','frontera');
title('Problema 3, Extra. Usando Pseudo-Inversa');
