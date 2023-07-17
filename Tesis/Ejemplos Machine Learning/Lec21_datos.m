%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 21 - generación de datos
%  Luis Alberto Rivera

%% Generación de muestras
% mu1 = [-1 0.5]'; mu2 = [0 -0.6]'; mu3 = [0.8 0.8]';
% Sig1 = 0.08*[1.5 0;0 1];
% Sig2 = 0.08*[1 0;0 1];
% Sig3 = 0.08*[1 0.5;0.5 1];
% 
% N = 250;
% X1 = mvnrnd(mu1,Sig1,N);
% X2 = mvnrnd(mu2,Sig2,N);
% X3 = mvnrnd(mu3,Sig3,N);
% X = [X1;X2;X3]; 
% X = X(randperm(size(X,1)),:);

% save L21_datos.mat X

load L21_datos.mat

X = X(randperm(size(X,1)),:);
umbral = 0.1;
q = 5;
[E,R] = BSAS(X, umbral, q);

figure(1); clf;
gscatter(X(:,1),X(:,2),E,[],[],15);
hold on;
scatter(R(:,1),R(:,2),50,'k','filled');
legend off
