%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 9 - Ejercicio 2
%  Luis Alberto Rivera

%% Distribuciones
mu1 = [0;0]; Sig1 = [1 0;0 1]; Pr1 = 0.5;
mu2 = [4;0]; Sig2 = [1 0;0 2]; Pr2 = 1-Pr1;

maxSig1 = max(diag(sqrt(Sig1)));
maxSig2 = max(diag(sqrt(Sig2)));

syms x1 x2
x = [x1;x2];

% Densidades
f1 = (1/(2*pi*sqrt(det(Sig1))))*exp(-0.5*(x-mu1)'*(Sig1\(x-mu1)));
f2 = (1/(2*pi*sqrt(det(Sig2))))*exp(-0.5*(x-mu2)'*(Sig2\(x-mu2)));

% Funciones discriminantes
g1 = -0.5*(x-mu1)'*(Sig1\(x-mu1))-0.5*log(det(Sig1))+log(Pr1);
g2 = -0.5*(x-mu2)'*(Sig2\(x-mu2))-0.5*log(det(Sig2))+log(Pr2);

% Frontera de decisión
g = g1 - g2;

limitesx1 = [mu1(1)-2.5*maxSig1, mu1(1)+2.5*maxSig1];
limitesy1 = [mu1(2)-2.5*maxSig1, mu1(2)+2.5*maxSig1];
limitesx2 = [mu2(1)-2.5*maxSig2, mu2(1)+2.5*maxSig2];
limitesy2 = [mu2(2)-2.5*maxSig2, mu2(2)+2.5*maxSig2];

figure(1); clf;
fcontour(f1,[limitesx1, limitesy1], 'LevelList',(1/(2*pi*sqrt(det(Sig1))))*exp(-0.5));
hold on
fcontour(f2,[limitesx2, limitesy2], 'LevelList',(1/(2*pi*sqrt(det(Sig2))))*exp(-0.5));

fimplicit(g, 'k', [min([limitesx1,limitesx2]),max([limitesx1,limitesx2]),...
                   min([limitesy1,limitesy2]),max([limitesy1,limitesy2])]);
grid on;


