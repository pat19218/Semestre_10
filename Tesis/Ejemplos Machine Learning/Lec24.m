%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 24 - Ejemplo
%  Luis Alberto Rivera

%% Generación de muestras
% mu1 = [-2 2]'; mu2 = [0 -2]'; mu3 = [1.5 1.5]';
% % mu4 = [1 4]'; mu5 = [2 12]';
% f = 0.8;
% Sig1 = f*[1.2 0;0 1]; Sig2 = f*[1 0;0 1]; Sig3 = f*[1 0.25;0.25 1];
% % Sig4 = f*[1 0;0 1]; Sig5 = f*[3 0;0 1];
% N1 = 60; N2 = 75; N3 = 80;
% % N4 = 120; N5 = 80;
%  
% X1 = mvnrnd(mu1,Sig1,N1); X2 = mvnrnd(mu2,Sig2,N2); X3 = mvnrnd(mu3,Sig3,N3);
% % X4 = mvnrnd(mu4,Sig4,N4); X5 = mvnrnd(mu5,Sig5,N5);
% X = [X1;X2;X3];%;X4;X5];
% X = X(randperm(size(X,1)),:);
%  
% outliers = [mvnrnd([8,-5],2*eye(2),5);mvnrnd([0,8],2*eye(2),5)];
% X_out = [X;outliers];
% X_out = X_out(randperm(size(X_out,1)),:);
% 
% save L24_datos.mat X X_out

load L24_datos.mat

figure(1); clf;
scatter(X(:,1),X(:,2),'filled');

m = 3; q = 2;
[U1, centros1_fcm] = fcm(X, m, q, 2);
[E1, centros1_km] = k_means(X, m, 3);

[U2, centros2_fcm] = fcm(X_out, m, q, 4);
[E2, centros2_km] = k_means(X_out, m, 5);


