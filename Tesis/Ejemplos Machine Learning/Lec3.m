%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 3
%  Luis Alberto Rivera

%% Ejemplo 5
mu = 1000;  sig = 10;
% P(R1<R<=R2);
R1 = 800; R2 = 1200;
P = 0.5*(erf((R2-mu)/(sqrt(2)*sig))-erf((R1-mu)/(sqrt(2)*sig)))


%% Ejercicio 1
a = 2; b = 6;
X1 = [linspace(a-2,a,50),linspace(a,b,50),linspace(b,b+2,50)];

% A mano
fX1 = [zeros(1,50),(1/(b-a))*ones(1,50),zeros(1,50)];
FX1 = [zeros(1,50),(X1(51:100)-a)/(b-a),ones(1,50)];  % X1-a resta a a cada elemento de X1

% Usando funciones de Matlab pdf/cdf (Statistics and Machine Learning toolbox)
fdp1 = unifpdf(X1,a,b);
fda1 = unifcdf(X1,a,b);

figure(1); clf;
subplot(2,1,1);
plot(X1,fX1,'b');
hold on;
plot(X1,FX1,'r');
legend('FDP','FDA');
title('A mano');

subplot(2,1,2);
plot(X1,fdp1,'b');
hold on;
plot(X1,fda1,'r');
legend('FDP','FDA');
title('Funciones pdf, cdf');

sgtitle('Distribución Uniforme');

%% Ejercicio 4
mu = 0; sig = 1;
X4 = linspace(mu-3*sig,mu+3*sig,100);

% A mano
fX4 = (1/(sqrt(2*pi)*sig))*exp(-0.5*((X4-mu)/sig).^2);  % .^ es para operar elemento por elemento
FX4 = 0.5*(1+erf((X4-mu)/(sig*sqrt(2))));

% Usando funciones de Matlab pdf/cdf
fdp4 = normpdf(X4,mu,sig);  % normpdf(X4) daría lo mismo, la dist. estándar
fda4 = normcdf(X4,mu,sig);  % normcdf(X4) daría lo mismo.

figure(4); clf;
subplot(2,1,1);
plot(X4,fX4,'b');
hold on;
plot(X4,FX4,'r');
legend('FDP','FDA');
title('A mano');

subplot(2,1,2);
plot(X4,fdp4,'b');
hold on;
plot(X4,fda4,'r');
legend('FDP','FDA');
title('Funciones  pdf, cdf');

sgtitle(sprintf('Distribución Normal, mu = %0.2f, sigma = %0.2f',mu,sig));
