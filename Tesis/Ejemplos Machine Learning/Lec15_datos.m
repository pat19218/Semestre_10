%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 15 - generación de datos
%  Luis Alberto Rivera

%% Generación de muestras
mu1 = [5 -2 0]'; mu2 = [2 -1 2]'; mu3 = [3 1 5]';
Sig1 = [3 0 0;0 2 0;0 0 1];
Sig2 = [1 -0.3 0.2;-0.3 1.5 0;0.2 0 2];
Sig3 = [2 0 -0.4;0 1 0.5;-0.4 0.5 1.5];

N = 1000;
X1 = mvnrnd(mu1,Sig1,N);
X2 = mvnrnd(mu2,Sig2,N);
X3 = mvnrnd(mu3,Sig3,N);

save L15_datos.mat X1 X2 X3

% Tranformación arbitraria (plano perpendicular al vector que pase por las
% medias m1 y m3
m1 = mean(X1);
m2 = mean(X2);
m3 = mean(X3);

syms x y z
p = (m1-[x y z])*(m1-m3)';

x = 0; y = 0;
z = double(solve(eval(p)));
v1 = m1 - [0 0 z];

syms x y z
y = 0; z = 0;
x = double(solve(eval(p)));
v2 = m1 - [x 0 0];

v1 = v1/norm(v1);
v2 = v2/norm(v2);
Arb = [v1',v2'];

