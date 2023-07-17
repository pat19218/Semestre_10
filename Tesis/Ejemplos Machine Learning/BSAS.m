%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Algoritmo Basic Sequential Algorithmic Scheme (BSAS)
%  Código original por: Alina Zare
%  Modificado y comentado por: Luis Alberto Rivera

% Entradas: X - matriz con las muestras como vectores fila (Nxd)
%      umbral - umbral para la distancia máxima al cluster más cercano (distance threshold)
%           q - máximo número de clusters

% Salida:   E - Vector con las etiquetas asignadas a las muestras
%           R - Matriz con los representantes de los clusters formados. En
%               este caso, son las medias de cada cluster.
function [E,R] = BSAS(X, umbral, q)
N = size(X,1);
m = 1;          % número de clusters (empieza en 1, puede ir aumentando)
E = zeros(N,1); % Inicializar vector de etiquetas.
E(1) = 1;       % El primer punto tiene la etiqueta 1.
R = X(1,:);     % Matriz con los representantes de los clusters. Empieza con uno,
                % puede ir teniendo más, según se vayan creando más clusters.

for n = 2:N
    % calcula la distancia entre la muestra y todos los representantes actuales
    distX = pdist2(X(n,:), R, 'euclidean');    % puede usarse otro tipo de distancias
    
    % Se encuentra la menor distancia (cluster más cercano)
    [dmin, e] = min(distX); % dmin es el valor, e es el número de cluster más cercano
    
    if((dmin > umbral) && (m < q))
        % Crear un nuevo cluster
        m = m + 1;
        E(n) = m;   % La muestra actual tendrá la etiqueta del cluster recién creado
        R(end+1,:) = X(n,:); % La muestra es el representante del nuevo cluster, por ahora.
    else
        % Agregar la muestra actual a un cluster existente
        % Lo siguiente recalcula el representante del cluster (se modifica el promedio)
        R(e,:) = (sum(E ==e)*R(e,:) + X(n,:))/(sum(E==e)+1);
        E(n) = e;   % Se asigna la etiqueta a la muestra (el número del cluster)
    end
end

end
