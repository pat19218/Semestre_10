%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Ejemplo de iteración circular
%  Luis Alberto Rivera

n = 10;     % número de muestras
kmax = 25;  % máximo número de iteraciones
cont = 0;   % contador de iteraciones
k = 0;      % índice "circular", que debe ir: 1,2,...,n,1,2,...,n,1,2,...

while (cont < kmax) % se pueden agregar condiciones con && (AND) o || (OR)
    cont = cont+1;
    k = mod(k,n)+1;
    
    % Hacer lo que haya que hacer...
    
    fprintf('Índice k: %d,  # de iteración: %d\n', k, cont);
    
    % Lo siguiente suspende ejecución por 0.25 segundos (sólo para que no se imprima
    % tan rápido). Esto no es necesario.
    pause(0.25);
end
