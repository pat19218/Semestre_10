%% IE3042 - Temas Especiales de Electr�nica y Mecatr�nica 2
%  Lecci�n 7 - Ejercicio 1, usando mvnpdf
%  Luis Alberto Rivera

% Distribuci�n normal bivariada (forma matricial)
mu = [0 0]; % media - �Atenci�n! Se usa como vector fila, para ser consistente con la
            % funci�n mvnpdf. Se pudo definir como vector columna (como en la definici�n
            % de la Lecci�n 7, y luego usar mu' en la funci�n mvnpdf.
Sig = [1 0;0 1];  % Matriz de covarianzas

maxSig = max([sqrt(Sig(1,1)),sqrt(Sig(2,2))]);

% Coordenadas x1 y x2 a usar
x1 = ((mu(1)-2.5*maxSig):0.1*maxSig:(mu(1)+2.5*maxSig));
x2 = ((mu(2)-2.5*maxSig):0.1*maxSig:(mu(2)+2.5*maxSig));

[X1,X2] = meshgrid(x1,x2);  % crea el "grid" de puntos a evaluar
             
X1_columna = reshape(X1,[],1);  % vector columna con todas las coordenadas x1 del grid
X2_columna = reshape(X2,[],1);  % vector columna con todas las coordenadas x2 del grid

X_todos = [X1_columna,X2_columna];  % Todos los vectores (fila) en una matriz
Z_todos = mvnpdf(X_todos,mu,Sig);  % Todas las im�genes de los vectores X_todos

pdf = reshape(Z_todos,size(X1,1),[]); % Para que coincidan con las matrices X1 y X2

% Gr�ficas
figure(1); clf;
surf(X1,X2,pdf);
xlabel('x1'); ylabel('x2'); zlabel('pdf');

figure(2); clf;
contour(X1,X2,pdf);
xlabel('x1'); ylabel('x2');
