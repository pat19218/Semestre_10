%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 25 - Ejemplo
%  Luis Alberto Rivera

%% Generación de muestras
% --- Conjunto a ---
% Xa = [0 2;...
%       2 6;...
%       1 0;...
%       3 3];

% --- Conjunto b ---
% mu1 = [0 0 0]'; mu2 = [1 2 -2]'; mu3 = [3 3 1]';
% f = 0.1;
% Sig1 = f*eye(3); Sig2 = f*eye(3); Sig3 = f*eye(3);
% N1 = 3; N2 = 5; N3 = 4;
%  
% X1 = mvnrnd(mu1,Sig1,N1); X2 = mvnrnd(mu2,Sig2,N2); X3 = mvnrnd(mu3,Sig3,N3);
% Xb = [X1;X2;X3];
% Xb = Xb(randperm(size(Xb,1)),:);

% --- Conjunto c ---
% mu1 = zeros(10,1); mu2 = 2*ones(10,1); mu3 = 4*ones(10,1); mu4 = 6*ones(10,1);
% Sig1 = 0.25*eye(10); Sig2 = 0.4*eye(10); Sig3 = 0.3*eye(10); Sig4 = 0.5*eye(10);
% N1 = 30; N2 = 60; N3 = 40; N4 = 50;
%  
% X1 = mvnrnd(mu1,Sig1,N1); X2 = mvnrnd(mu2,Sig2,N2); X3 = mvnrnd(mu3,Sig3,N3);
% X4 = mvnrnd(mu4,Sig4,N4);
% Xc = [X1;X2;X3;X4];
% Xc = Xc(randperm(size(Xc,1)),:);

% save L25_datos.mat Xa Xb Xc

load L25_datos.mat

figure(1); clf;
scatter(Xa(:,1),Xa(:,2),'filled');
grid on;

figure(2); clf;
[Da, Pa] = VAT(Xa);

figure(3); clf;
scatter3(Xb(:,1),Xb(:,2),Xb(:,3),'filled');
xlabel('x'); ylabel('y'); zlabel('z');
grid on;

figure(4); clf;
[Db, Pb] = VAT(Xb);

figure(5); clf;
[Dc, Pc] = VAT(Xc);
