%% IE3042 - Temas Especiales de Electr�nica y Mecatr�nica 2
%  Algoritmo Fuzzy c-means
%  C�digo original por: Alina Zare
%  Modificado y comentado por: Luis Alberto Rivera

% Entradas: X - matriz con las muestras como vectores fila (Nxd)
%           m - n�mero de clusters deseado
%           q - Fuzzifier (debe ser > 1)
%          op - opci�n para ir mostrando los resultados parciales o no
%               Si op = 0, no se muestran los datos. Si op > 1, se muestran los
%               datos en la figura n�mero op (debe ser n�mero entero).
%               Esta opci�n se ignora si la dimensionalidad de los datos no es 2 � 3.

% Salidas:  U - Matriz con los valores de pertenencia uij
%     centros - Matriz con los representantes de los clusters formados ("centros").
function [U, centros] = fcm(X, m, q, op)
% Par�metros para detener el algoritmo. Se pueden ajustar seg�n se necesite.
MaxIter     = 1000;
StopThresh  = 1e-5;

dim = size(X,2);    % dimensionalidad de los datos
if((dim < 2) || (dim > 3))
    op = 0;         % La opci�n de graficar s�lo se considera si los datos son 2D � 3D
end

if(op ~= 0)
    figure(op); clf;    % Para limpiar la figura
end

% Inicializar los centros tomando muestras al azar (se podr�an usar otros m�todos)
N = size(X,1);          % n�mero de muestras
rp = randperm(N);       % permutaci�n aleatoria de los n�meros 1:N
centros = X(rp(1:m),:); % selecciona los primeros m puntos, ordenados seg�n rp

% Otras inicializaciones
diferencia = inf;
iter = 0;
U = zeros(N,m); 

% El algoritmo sigue mientras la diferencia entre los centros sea mayor que
% un umbral, y no se haya llegado al n�mero m�ximo de iteraciones.
while(diferencia > StopThresh && iter < MaxIter)
    D = pdist2(X, centros).^2; % Dist. de las muestras a los centros (cuadrado de Euclideana)
    for i = 1:N
        for j = 1:m
            if(D(i,j) ~= 0)
                U(i,j) = 1/sum((D(i,j)./D(i,:)).^(1/(q-1)));
            else
                U(i,j) = 1;
            end
        end
    end
        
    if(op ~= 0)
        % Muestra los clusters actualizados
        figure(op);
        if(dim == 3)
            for j = 1:m     % se muestra una gr�fica por cluster, con todas las membres�as
                subplot(1,m,j);
                hold off;
                scatter3(X(:,1), X(:,2), X(:,3), 20, U(:,j), 'filled');
                hold on;
                scatter3(centros(:,1), centros(:,2), centros(:,3), 80, 'k', 'filled');
            end
        else
            for j = 1:m     % se muestra una gr�fica por cluster, con todas las membres�as
                subplot(1,m,j);
                hold off;
                scatter(X(:,1), X(:,2), 20, U(:,j), 'filled');
                hold on;
                scatter(centros(:,1), centros(:,2), 80, 'k', 'filled');
            end
        end
        title(['Iteraci�n: ', num2str(iter), ' Diferencia: ', num2str(diferencia)]);
        pause(0.01);
    end
    
    % Actualiza los representates de los clusters
    centrosPrev = centros;
    for j = 1:m
        Xw = repmat(U(:,j).^q,[1, dim]).*X;
        centros(j,:) = sum(Xw)/sum(U(:,j).^q);
    end
    
    % Actualiza la differencia y el contador de iteraciones, para el criterio de detenci�n
    diferencia = norm(centrosPrev - centros);
    iter = iter+1;
end

if(op ~= 0)
    % Mostrar el clustering final
    figure(op);
    if(dim == 3)
        for j = 1:m
            subplot(1,m,j);
            hold off;
            scatter3(X(:,1), X(:,2), X(:,3), 20, U(:,j), 'filled');
            hold on;
            scatter3(centros(:,1), centros(:,2), centros(:,3), 80, 'k', 'filled');
            colorbar('southoutside');
            title(['Pertenencias a Cluster ', num2str(j)]);
        end
    else
        for j = 1:m
            subplot(1,m,j);
            hold off;
            scatter(X(:,1), X(:,2), 20, U(:,j), 'filled');
            hold on;
            scatter(centros(:,1), centros(:,2), 80, 'k', 'filled');
            colorbar('southoutside');
            title(['Pertenencias a Cluster ', num2str(j)]);
        end
    end
    sgtitle(['FINAL - No. de iteraciones: ',num2str(iter),...
             ' Diferencia: ',num2str(diferencia), ', q = ', num2str(q)]);
end

end

