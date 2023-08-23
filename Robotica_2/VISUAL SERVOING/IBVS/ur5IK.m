% =========================================================================
% MT3006 - LABORATORIO 1
% -------------------------------------------------------------------------
% Complete el algoritmo de cinemática inversa que permita que no sólo el
% manipulador alcance una posición planar (xd,yd) deseada en el efector
% final sino que emplee los grados de libertad inactivos para
% reconfigurarse tal que se maximice una función objetivo secundaria, según
% lo descrito en la guía.
% =========================================================================
function [q,Q] = ur5IK(Td, q0)
    tol_p = 1e-06; % Tolerancia del error de posición
    % Número máximo de iteraciones (reducir en caso de mala performance 
    % durante la simulación)
    K = 200; 
    
    % Inicialización de variables
    q = q0;
    n = numel(q);
    Q = zeros(n, K);
    Q(:,1) = q; 
    k = 0;
    
    % Se extrae la posición deseada y se inicializa el error con la
    % posición extraída de la pose actual
    td = Td(1:3, 4);
    T = ur5FK(q);
    t = T(1:3, 4);
    e_p = td - t;
    
    % Complete el ciclo responsable de implementar el método iterativo, 
    % según el algoritmo descrito en la guía
    while((norm(e_p) > tol_p) && (k < K))
        T = ur5FK(q);
        t = T(1:3, 4);
        e_p = td - t;
        J = ur5J(q);
        Jv = J(1:3,:); % jacobiano de velocidad lineal

        % -----------------------------------------------------------------
        % El cálculo de la inversa, la velocidad de reconfiguración y el
        % algoritmo iterativo deben ir aquí
        % -----------------------------------------------------------------
        % Se selecciona el método para calcular la inversa del jacobiano
        invsel = 'traspuesta';
        
        switch invsel
            case 'pseudoinversa'
                Ji = pinv(Jv);
            case 'traspuesta'
%                 alpha = (e_p'*(Jv*Jv')*e_p) / (e_p'*(Jv*Jv')*(Jv*Jv')*e_p);
                alpha = 0.05;
                Ji = alpha*Jv'; 
            case 'levenberg'
                Ji = Jv'/(Jv*Jv'+(0.1)^2*eye(3));
            otherwise
                Ji = pinv(Jv);
        end
        
        % Se actualiza el algoritmo iterativo de cinemática inversa
        q = q + Ji*e_p; 
        
        k = k + 1; % Se incrementa el número de iteración
        Q(:,k+1) = q; % Se almacena la configuración en el histórico
    end
    
    Q = Q(:,1:k+1); % Se extrae sólo la parte del histórico que se empleó
end