%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Calificación del Segundo Parcial
%  Luis Alberto Rivera

%% Problema 3
load Parcial2_pr3.mat
Ntest1 = size(Xtest1,1); Ntest2 = size(Xtest2,1);
Ytest1 = [ones(Ntest1,1),Xtest1];
Ytest2 = -1*[ones(Ntest2,1),Xtest2];
syms x1 x2 x3
x = [x1;x2;x3];

% a)
a3_a = [0,0,0,0]';
% b)
clasif_c1_b = a3_a'*Ytest1';
correctos_c1_b = sum(clasif_c1_b > 0)
incorrectos_c1_b = Ntest1 - correctos_c1_b
clasif_c2_b = a3_a'*Ytest2';
correctos_c2_b = sum(clasif_c2_b > 0)
incorrectos_c2_b = Ntest2 - correctos_c2_b

% c)
a3_c = [0,0,0,0]';
% d)
clasif_c1_d = a3_c'*Ytest1';
correctos_c1_d = sum(clasif_c1_d > 0)
incorrectos_c1_d = Ntest1 - correctos_c1_d
clasif_c2_d = a3_c'*Ytest2';
correctos_c2_d = sum(clasif_c2_d > 0)
incorrectos_c2_d = Ntest2 - correctos_c2_d

% e)
g3_a = a3_a(1) + a3_a(2:4)'*x;
figure(7); clf;
scatter3(Xtrain1(:,1),Xtrain1(:,2),Xtrain1(:,3),'b','filled');
hold on;
scatter3(Xtrain2(:,1),Xtrain2(:,2),Xtrain2(:,3),'r','filled');
% scatter3(Xtest1(:,1),Xtest1(:,2),Xtest1(:,3),'c','filled');
% hold on
% scatter3(Xtest2(:,1),Xtest2(:,2),Xtest2(:,3),'m','filled');
% fimplicit3(g3_a,[-1 1.5 -2 4 -1 1]);
fimplicit3(g3_a);
xlabel('x'); ylabel('y'); zlabel('z');
grid on;

g3_c = a3_c(1) + a3_c(2:4)'*x;
figure(8); clf;
scatter3(Xtrain1(:,1),Xtrain1(:,2),Xtrain1(:,3),'b','filled');
hold on;
scatter3(Xtrain2(:,1),Xtrain2(:,2),Xtrain2(:,3),'r','filled');
% scatter3(Xtest1(:,1),Xtest1(:,2),Xtest1(:,3),'c','filled');
% hold on;
% scatter3(Xtest2(:,1),Xtest2(:,2),Xtest2(:,3),'m','filled');
fimplicit3(g3_c,[-1 1.5 -2 4 -1 1]);
xlabel('x'); ylabel('y'); zlabel('z');
grid on;

%% Problema 4
load Parcial2_pr4_clave.mat etiquetas

R = Rand_index(E_pr4,etiquetas);
nota = R*10
