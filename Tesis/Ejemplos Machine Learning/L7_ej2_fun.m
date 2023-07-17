%% IE3042 - Temas Especiales de Electr�nica y Mecatr�nica 2
%  Lecci�n 7 - Ejercicio 2
%  Luis Alberto Rivera

% Funci�n que implementa una tranformaci�n de distribuci�n. Genera los puntos
% y obtiene los valores de la densidad tranformada.

% Entradas: mu - vector columna con la media de la distribuci�n original.
%                Se asume de dimensi�n d = 2.
%          Sig - matriz de covarianzas de la distribuci�n original (2x2)
%            A - matriz de tranformaci�n (2x2 � 2x1)
%            N - n�mero de puntos por dimensi�n

% Salidas:  muT - vector columna con la media transformada
%          SigT - matriz de covarianzas transformada
%            X1 - Puntos de la variable x1. Si la dist. transformada es de dim k=2,
%                 esta variable es una matriz de NxN (grid). Si la dist.
%                 transformada es de k=1, esta variable es un vector de Nx1
%            X2 - Puntos de la variable x2. Si la dist. transformada es de dim k=2,
%                 esta variable es una matriz de NxN (grid). Si la dist.
%                 transformada es de k=1, esta variable es un vector vac�o.
%             Z - Valores de la pdf. Si la dist. transformada es de dim k=2,
%                 esta variable es una matriz de NxN (grid). Si la dist.
%                 transformada es de k=1, esta variable es un vector de Nx1.
function [muT,SigT,X1,X2,Z] = L7_ej2_fun(mu,Sig,A,N)

if size(mu,1) < size(mu,2)    % Para asegurarse que mu es vector columna
    mu = mu';
end

if size(A,1) < size(A,2)    % Para asegurarse que A no sea un vector fila
    A = A';
end

k = size(A,2);  % dimensi�n de los vectores tranformados

% Aplicaci�n de las transformaciones
muT = A'*mu;
SigT = A'*Sig*A;

maxSig = max(diag(sqrt(SigT)));

if k == 1   % Transformaci�n a un espacio unidimensional
    X1 = linspace(muT-2.5*maxSig,muT+2.5*maxSig,N)';
    X2 = [];
    Z = normpdf(X1,muT,sqrt(SigT));
else        % Transformaci�n a un espacio bidimensional
    % Coordenadas x1 y x2 a usar
    x1 = linspace(muT(1)-2.5*maxSig,muT(1)+2.5*maxSig,N); %((muT(1)-2.5*maxSig):0.1*maxSig:(mu(1)+2.5*maxSig));
    x2 = linspace(muT(2)-2.5*maxSig,muT(2)+2.5*maxSig,N);
    [X1,X2] = meshgrid(x1,x2);  % crea el "grid" de puntos a evaluar
    X1_columna = reshape(X1,[],1);  % vector columna con todas las coordenadas x1 del grid
    X2_columna = reshape(X2,[],1);  % vector columna con todas las coordenadas x2 del grid
    X_todos = [X1_columna,X2_columna];  % Todos los vectores (fila) en una matriz
    Z_todos = mvnpdf(X_todos,muT',SigT);  % Todas las im�genes de los vectores X_todos
    Z = reshape(Z_todos,size(X1,1),[]); % Para que coincidan con las matrices X1 y X2
end

end