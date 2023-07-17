%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 4
%  Luis Alberto Rivera

% Distribución normal bivariada, centrada en (0,0)
rho = 0.9; sig = 1;
[X,Y] = meshgrid(-2.5*sig:0.1*sig:2.5*sig,-2.5*sig:0.1*sig:2.5*sig);
Z = (1/(2*pi*sig^2*sqrt(1-rho^2)))*exp(-(X.^2+Y.^2-2*rho*X.*Y)/(2*(1-rho^2)*sig^2));

figure(1); clf;
surf(X,Y,Z);
xlabel('x'); ylabel('y'); zlabel('f(x,y)');

figure(2); clf;
contour(X,Y,Z);
xlabel('x'); ylabel('y');
