%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 14
%  Luis Alberto Rivera

%% Generación de muestras
% mu11 = [1.5 3]'; mu12 = [2 5]'; mu13 = [4 6]';
% factor = 0.4;
% Sig11 = factor*[1 0;0 2]; Sig12 = factor*[1 0;0 1]; Sig13 = factor*[2 0;0 1];
% 
% mu21 = [4 2]'; mu22 = [6 3]';
% Sig21 = factor*[1 0;0 2]; Sig22 = 0.5*factor*[1 0;0 1.5];
% 
% N = 300;
% X1 = [mvnrnd(mu11,Sig11,N);mvnrnd(mu12,Sig12,N);mvnrnd(mu13,Sig13,N)];
% X2 = [mvnrnd(mu21,Sig21,1.5*N);mvnrnd(mu22,Sig22,1.5*N)];
% 
% trot = -10*pi/180;
% Arot = [cos(trot) -sin(trot);sin(trot) cos(trot)];
% X1 = (Arot'*X1')';
% X2 = (Arot'*X2')';

load L14_datos.mat

figure(1); clf;
hold on;
scatter(X1(:,1),X1(:,2),'b');
scatter(X2(:,1),X2(:,2),'r');
grid on;
legend('Clase 1','Clase 2');
title('Muestras Originales');

%% Discriminante lineal de Fisher
m1 = mean(X1);
m2 = mean(X2);
n1 = size(X1,1);
n2 = size(X2,1);

Sw = (n1-1)*cov(X1) + (n2-1)*cov(X2);
w = Sw\(m1'-m2');
w = w/norm(w)

%% Proyecciones varias, incluyendo al vector de Fisher
% dirección [1 1]
dir1 = [1 1]'/norm([1 1]);
X1_1 = (dir1'*X1')';
X2_1 = (dir1'*X2')';

% dirección [-3 1]
dir2 = [-3 1]'/norm([-3 1]);
X1_2 = (dir2'*X1')';
X2_2 = (dir2'*X2')';

% dirección w
X1_w = (w'*X1')';
X2_w = (w'*X2')';

%% Gráficas
N1 = size(X1,1); N2 = size(X2,1);
ajuste = 0.05;
figure(2); clf;
scatter(X1(:,1),-2*ones(N1,1)+ajuste,'b');
hold on;
scatter(X2(:,1),-2*ones(N2,1)-ajuste,'r');

scatter(X1(:,2),-ones(N1,1)+ajuste,'b');
scatter(X2(:,2),-ones(N2,1)-ajuste,'r');

scatter(X1_1,zeros(N1,1)+ajuste,'b');
scatter(X2_1,zeros(N2,1)-ajuste,'r');

scatter(X1_2,ones(N1,1)+ajuste,'b');
scatter(X2_2,ones(N2,1)-ajuste,'r');

scatter(X1_w,2*ones(N1,1)+ajuste,'b');
scatter(X2_w,2*ones(N2,1)-ajuste,'r');

ylim([-3 3]);
grid on;
yticks([-2 -1 0 1 2]);
yticklabels({'[1 0]','[0 1]','[1 1]','[-3 1]','w'});
title('Proyecciones en varias direcciones');

