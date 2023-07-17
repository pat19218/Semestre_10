%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 7 - Ejercicio 3
%  Luis Alberto Rivera

%% Distribución
mu = [0;-4];
Sig = [1.5 0.7;0.7 1];

% Eigenvectores y Eigenvalores
[Phi,Lambda] = eig(Sig);
raiz_lambdas = sqrt(diag(Lambda));

eje1 = [mu,mu+raiz_lambdas(1)*Phi(:,1)];
eje2 = [mu,mu+raiz_lambdas(2)*Phi(:,2)];

maxSig = max(diag(sqrt(Sig)));
N = 50; % número de puntos por dimensión

% Coordenadas x1 y x2 a usar
x1 = linspace(mu(1)-2.5*maxSig,mu(1)+2.5*maxSig,N);
x2 = linspace(mu(2)-2.5*maxSig,mu(2)+2.5*maxSig,N);
[X1,X2] = meshgrid(x1,x2);  % crea el "grid" de puntos a evaluar
X1_columna = reshape(X1,[],1);  % vector columna con todas las coordenadas x1 del grid
X2_columna = reshape(X2,[],1);  % vector columna con todas las coordenadas x2 del grid
X_todos = [X1_columna,X2_columna];  % Todos los vectores (fila) en una matriz
Z_todos = mvnpdf(X_todos,mu',Sig);  % Todas las imágenes de los vectores X_todos
pdf = reshape(Z_todos,size(X1,1),[]); % Para que coincidan con las matrices X1 y X2

figure(3); clf;
contour(X1,X2,pdf);
hold on;
plot(eje1(1,:),eje1(2,:),'k','LineWidth',1);
plot(eje2(1,:),eje2(2,:),'k','LineWidth',1);
grid on;
xlabel('x1'); ylabel('x2');
title('Contornos y Eigenvectores');
