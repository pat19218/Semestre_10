%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 6
%  Luis Alberto Rivera

mu1 = 5; sig1 = 1; Pr1 = 0.7;
mu2 = 7; sig2 = 2; Pr2 = 1-Pr1;
Xmin = min([mu1-3*sig1,mu2-3*sig2]);
Xmax = max([mu1+3*sig1,mu2+3*sig2]);

N = 500;
X = linspace(Xmin,Xmax,N);

% Verosimilitudes
f1 = (1/(sqrt(2*pi)*sig1))*exp(-0.5*((X-mu1)/sig1).^2);
f2 = (1/(sqrt(2*pi)*sig2))*exp(-0.5*((X-mu2)/sig2).^2);

% Evidencia
px = f1*Pr1 + f2*Pr2;

% Posteriores
F1 = Pr1*f1./px;
F2 = Pr2*f2./px;

% Función discriminante
gx = log(f1./f2)+log(Pr1/Pr2);

% Gráficas
figure(3); clf;
subplot(3,1,1);
hold on;
plot(X,f1,'b');
plot(X,f2,'r');
xlim([Xmin,Xmax]);
grid on;
legend('w1','w2');
title('Verosimilitudes');

subplot(3,1,2);
hold on;
plot(X,F1,'b');
plot(X,F2,'r');
xlim([Xmin,Xmax]);
ylim([0,1]);
grid on;
legend('w1','w2');
title('Posteriores');

subplot(3,1,3);
plot(X,gx,'k');
xlim([Xmin,Xmax]);
ylim([min(gx)-0.1*(max(gx)-min(gx)),max(gx)+0.1*(max(gx)-min(gx))]);
grid on;
title('Función Discriminante');

sgtitle(sprintf('w1: mu = %0.1f, sigma = %0.1f;  w2: mu = %0.1f, sigma = %0.1f',...
                 mu1,sig1,mu2,sig2));
