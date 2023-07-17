%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 5
%  Luis Alberto Rivera

mu1 = 5; sig1 = 1; Pr1 = 0.5;

% Usando plot
figure(1); clf;
X = linspace(mu1-3*sig1,mu1+3*sig1,100);
px1 = (1/(sqrt(2*pi)*sig1))*exp(-0.5*((X-mu1)/sig1).^2);
plot(X,px1,'g');
xlabel('x');
ylabel('p(x|w1)');

% Usando fplot
figure(2); clf;
fplot(@(x) (1/(sqrt(2*pi)*sig1))*exp(-0.5*((x-mu1)/sig1).^2),...
           [mu1-3*sig1,mu1+3*sig1], 'b');
xlabel('x');
ylabel('p(x|w1)');
