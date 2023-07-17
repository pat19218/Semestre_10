%% IE3042 - Temas Especiales de Electr�nica y Mecatr�nica 2
%  Ejemplo de iteraci�n circular
%  Luis Alberto Rivera

n = 10;     % n�mero de muestras
kmax = 25;  % m�ximo n�mero de iteraciones
cont = 0;   % contador de iteraciones
k = 0;      % �ndice "circular", que debe ir: 1,2,...,n,1,2,...,n,1,2,...

while (cont < kmax) % se pueden agregar condiciones con && (AND) o || (OR)
    cont = cont+1;
    k = mod(k,n)+1;
    
    % Hacer lo que haya que hacer...
    
    fprintf('�ndice k: %d,  # de iteraci�n: %d\n', k, cont);
    
    % Lo siguiente suspende ejecuci�n por 0.25 segundos (s�lo para que no se imprima
    % tan r�pido). Esto no es necesario.
    pause(0.25);
end
