%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Segundo Parcial
%  Luis Alberto Rivera

%% Problema 2
% Generación de muestras
% mu1 = [-5 5]'; mu2 = [0 -3]'; mu3 = [8 8]'; mu4 = [1 4]'; mu5 = [2 12]';
% Sig1 = 2*[1.2 0;0 1]; Sig2 = 2*[1 0;0 1]; Sig3 = 2*[1 0.2;0.2 1];
% Sig4 = 2*[1 0;0 1]; Sig5 = 2*[1.3 0;0 1];
% N1 = 100; N2 = 150; N3 = 200; N4 = 120; N5 = 80;
% 
% X1 = mvnrnd(mu1,Sig1,N1); X2 = mvnrnd(mu2,Sig2,N2); X3 = mvnrnd(mu3,Sig3,N3);
% X4 = mvnrnd(mu4,Sig4,N4); X5 = mvnrnd(mu5,Sig5,N5);
% X = [X1;X2;X3;X4;X5];
% X = X(randperm(size(X,1)),:);
% Xpeq = [X1;X4];
% Xpeq = Xpeq(randperm(size(Xpeq,1)),:);
% 
% outliers = [mvnrnd([15,-10],4*eye(2),5);mvnrnd([0,25],4*eye(2),5)];
% X_out = [X;outliers];
% X_out = X_out(randperm(size(X_out,1)),:);
% 
% outlierspeq = [mvnrnd([8,-5],3*eye(2),5);mvnrnd([0,15],3*eye(2),5)];
% Xpeq_out = [Xpeq;outlierspeq];
% Xpeq_out = Xpeq_out(randperm(size(Xpeq_out,1)),:);
%  
% save Parcial2.mat X X_out Xpeq Xpeq_out

%
% Clave: gráfica-método
% gA-m7, gB-m5, gC-m1, gD-m2, gE-m9, gF-m8

load Parcial2_pr3.mat

X = X(randperm(size(X,1)),:);
X_out = X_out(randperm(size(X_out,1)),:);
Xpeq = Xpeq(randperm(size(Xpeq,1)),:);
Xpeq_out = Xpeq_out(randperm(size(Xpeq_out,1)),:);

umbral = 0.1; q = 5;
[EA,RA] = BSAS(X, umbral, q);
figure(1); clf;
gscatter(X(:,1),X(:,2),EA,[],[],15);
hold on;
scatter(RA(:,1),RA(:,2),50,'k','filled');
legend off

m = 5;
[EB, RB] = k_means(X, m, 0);
figure(2); clf;
gscatter(X(:,1),X(:,2),EB,[],[],15);
hold on;
scatter(RB(:,1),RB(:,2),50,'k','filled');
legend off

m = 3; q = 1.5;
[UC, RC] = fcm(Xpeq, m, q, 0);
figure(3); clf;
scatter(Xpeq(:,1),Xpeq(:,2),[],UC(:,1),'filled');
hold on;
scatter(RC(:,1),RC(:,2),100,'k','filled');

umbral = 18; q = 7;
[ED,RD] = BSAS(X_out, umbral, q);
figure(4); clf;
gscatter(X_out(:,1),X_out(:,2),ED,[],[],15);
hold on;
scatter(RD(:,1),RD(:,2),50,'k','filled');
legend off

m = 4;
[EE, RE] = k_means(X_out, m, 0);
figure(5); clf;
gscatter(X_out(:,1),X_out(:,2),EE,[],[],15);
hold on;
scatter(RE(:,1),RE(:,2),50,'k','filled');
legend off

m = 3; q = 4;
[UF, RF] = fcm(Xpeq, m, q, 0);
figure(6); clf;
scatter(Xpeq(:,1),Xpeq(:,2),[],UF(:,1),'filled');
hold on;
scatter(RF(:,1),RF(:,2),100,'k','filled');

%% Problema 3
% mu1 = [0 0 0]'; mu2 = [1 2 0]';
% Sig1 = 0.07*[2 0.1 -0.1;0.1 3 0.2;-0.1 0.2 0.1];
% Sig2 = 0.1*[0.5 -0.1 0.1;-0.1 2 0.2;0.1 0.2 3];
% Ntrain1 = 50; Ntrain2 = 60;
% Ntest1 = 25; Ntest2 = 25; Ntest1error = 3; Ntest2error = 2;
% 
% Xtrain1 = mvnrnd(mu1,Sig1,Ntrain1); Xtrain2 = mvnrnd(mu2,Sig2,Ntrain2);
% Xtest1 = [mvnrnd(mu1,Sig1,Ntest1-Ntest1error);mvnrnd(mu2,Sig2,Ntest1error)];
% Xtest2 = [mvnrnd(mu2,Sig2,Ntest2-Ntest2error);mvnrnd(mu1,Sig1,Ntest2error)];
% 
% save Parcial2_pr3.mat Xtrain1 Xtrain2 Xtest1 Xtest2

load Parcial2_pr3.mat
Ntrain1 = size(Xtrain1,1); Ntrain2 = size(Xtrain2,1);
Ntest1 = size(Xtest1,1); Ntest2 = size(Xtest2,1);

Ytrain = [[ones(Ntrain1,1),Xtrain1];-[ones(Ntrain2,1),Xtrain2]]; % "Normalizar" las muestras de la clase 2
Ytest1 = [ones(Ntest1,1),Xtest1];
Ytest2 = -1*[ones(Ntest2,1),Xtest2];

syms x1 x2 x3
x = [x1;x2;x3];

% --- inciso a ---
eta = 0.01; th = 1e-7; kmax = 500;
[a3_a, k] = batch_perceptron(Ytrain', eta, th, kmax, 0);  % a = [w0 w']'

% --- inciso b ---
clasif_c1_b = a3_a'*Ytest1';
correctos_c1_b = sum(clasif_c1_b > 0)
incorrectos_c1_b = Ntest1 - correctos_c1_b

clasif_c2_b = a3_a'*Ytest2';
correctos_c2_b = sum(clasif_c2_b > 0)
incorrectos_c2_b = Ntest2 - correctos_c2_b

% --- inciso c ---
b3 = ones(Ntrain1+Ntrain2,1);   % Vector de márgenes
PseudoI = (Ytrain'*Ytrain)\Ytrain';
a3_c = PseudoI*b3;  % a = [w0 w']'

% --- inciso d ---
clasif_c1_d = a3_c'*Ytest1';
correctos_c1_d = sum(clasif_c1_d > 0)
incorrectos_c1_d = Ntest1 - correctos_c1_d

clasif_c2_d = a3_c'*Ytest2';
correctos_c2_d = sum(clasif_c2_d > 0)
incorrectos_c2_d = Ntest2 - correctos_c2_d

% --- inciso e (extra) ---
% parte a
g3_a = a3_a(1) + a3_a(2:4)'*x;
figure(7); clf;
scatter3(Xtrain1(:,1),Xtrain1(:,2),Xtrain1(:,3),'b','filled');
hold on;
scatter3(Xtrain2(:,1),Xtrain2(:,2),Xtrain2(:,3),'r','filled');
scatter3(Xtest1(:,1),Xtest1(:,2),Xtest1(:,3),'c','filled');
% hold on
scatter3(Xtest2(:,1),Xtest2(:,2),Xtest2(:,3),'m','filled');
fimplicit3(g3_a,[-1 1.5 -2 4 -1 1]);
xlabel('x'); ylabel('y'); zlabel('z');
legend('C1 Train','C2 Train','C1 Test','C2 Test','frontera');
title('Problema 3, Extra. Usando Batch Perceptron');

% parte c
g3_c = a3_c(1) + a3_c(2:4)'*x;
figure(8); clf;
scatter3(Xtrain1(:,1),Xtrain1(:,2),Xtrain1(:,3),'b','filled');
hold on;
scatter3(Xtrain2(:,1),Xtrain2(:,2),Xtrain2(:,3),'r','filled');
scatter3(Xtest1(:,1),Xtest1(:,2),Xtest1(:,3),'c','filled');
% hold on;
scatter3(Xtest2(:,1),Xtest2(:,2),Xtest2(:,3),'m','filled');
fimplicit3(g3_c,[-1 1.5 -2 4 -1 1]);
xlabel('x'); ylabel('y'); zlabel('z');
grid on;
legend('C1 Train','C2 Train','C1 Test','C2 Test','frontera');
title('Problema 3, Extra. Usando Pseudo-Inversa');

%% Problema 4
% d = 6;
% mu1 = zeros(d,1); mu2 = 2*ones(d,1); mu3 = 4*ones(d,1);
% Sig1 = 0.5*eye(d); Sig2 = 0.5*eye(d); Sig3 = 0.4*eye(d);
% N1 = 60; N2 = 80; N3 = 50;
% 
% X1 = mvnrnd(mu1,Sig1,N1); X2 = mvnrnd(mu2,Sig2,N2); X3 = mvnrnd(mu3,Sig3,N3);
% Xpr4 = [X1;X2;X3];
% ind_random = randperm(size(Xpr4,1))';
% Xpr4 = Xpr4(ind_random,:);
% 
% save Parcial2_pr4.mat Xpr4
% 
% etiquetas = [ones(N1,1);2*ones(N2,1);3*ones(N3,1)];
% etiquetas = etiquetas(ind_random);
% 
% save Parcial2_pr4_clave.mat Xpr4 X1 X2 X3 N1 N2 N3 ind_random etiquetas

load Parcial2_pr4.mat

figure(9); clf;
[Dpr4, Ppr4] = VAT(Xpr4);
[E_pr4, Rpr4] = k_means(Xpr4, 3, 0);

% Validación de Clustering: Usar las etiquetas


