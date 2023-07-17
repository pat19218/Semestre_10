%% IE3042 - Temas Especiales de Electr�nica y Mecatr�nica 2
%  Lecci�n 7 - Ejercicio 4
%  Luis Alberto Rivera

%% Distribuci�n Original
mu = [2;1];
Sig = [3 0;0 2];

% Eigenvectores y Eigenvalores
[Phi,Lambda] = eig(Sig);

maxSig = max(diag(sqrt(Sig)));
N = 50; % n�mero de puntos por dimensi�n

% Coordenadas x1 y x2 a usar
x1 = linspace(mu(1)-2.5*maxSig,mu(1)+2.5*maxSig,N);
x2 = linspace(mu(2)-2.5*maxSig,mu(2)+2.5*maxSig,N);
[X1,X2] = meshgrid(x1,x2);  % crea el "grid" de puntos a evaluar
X1_columna = reshape(X1,[],1);  % vector columna con todas las coordenadas x1 del grid
X2_columna = reshape(X2,[],1);  % vector columna con todas las coordenadas x2 del grid
X_todos = [X1_columna,X2_columna];  % Todos los vectores (fila) en una matriz
Z_todos = mvnpdf(X_todos,mu',Sig);  % Todas las im�genes de los vectores X_todos
pdf = reshape(Z_todos,size(X1,1),[]); % Para que coincidan con las matrices X1 y X2

screensize = get(groot, 'Screensize');  % Obtiene el tama�o del monitor
h0 = figure(10); clf;
% Lo siguiente es para que la figura tenga un tama�o espec�fico.
% Para ello, se necesita el "handler" de la figura (h0).
set(h0, 'OuterPosition',[0, screensize(4)/6, screensize(3), 5*screensize(4)/6]);
subplot(1,2,1);
surf(X1,X2,pdf);
xlabel('x1'); ylabel('x2'); zlabel('pdf');
title('Densidad');
subplot(1,2,2);
contour(X1,X2,pdf);
grid on;
xlabel('x1'); ylabel('x2');
title('Contornos');
sgtitle('Distribuci�n Original');


%% Transformaci�n de Whitening
Aw = Phi*Lambda^(-1/2);

% Llamado a la funci�n L7_ej2_fun
[muT2,SigT2,X1_2,X2_2,pdf2] = L7_ej2_fun(mu,Sig,Aw,N);

h2 = figure(2); clf;
set(h2, 'OuterPosition',[0, screensize(4)/12, screensize(3), 5*screensize(4)/6]);
subplot(1,2,1);
surf(X1_2,X2_2,pdf2);
xlabel('x1'); ylabel('x2'); zlabel('pdf');
title('Densidad');
subplot(1,2,2);
contour(X1_2,X2_2,pdf2);
grid on;
xlabel('x1'); ylabel('x2');
title('Contornos');
sgtitle('Distribuci�n Whitened');