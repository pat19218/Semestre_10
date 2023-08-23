% =========================================================================
% MT3006 - LABORATORIO 1
% -------------------------------------------------------------------------
% Complete el algoritmo de cinem�tica inversa que permita que no s�lo el
% manipulador alcance una posici�n planar (xd,yd) deseada en el efector
% final sino que emplee los grados de libertad inactivos para
% reconfigurarse tal que se maximice una funci�n objetivo secundaria, seg�n
% lo descrito en la gu�a.
% =========================================================================
function [q,Q] = ur5IK(Td, q0)
    tol_p = 1e-06; % Tolerancia del error de posici�n
    % N�mero m�ximo de iteraciones (reducir en caso de mala performance 
    % durante la simulaci�n)
    K = 200; 
    
    % Inicializaci�n de variables
    q = q0;
    n = numel(q);
    Q = zeros(n, K);
    Q(:,1) = q; 
    k = 0;
    
    % Se extrae la posici�n deseada y se inicializa el error con la
    % posici�n extra�da de la pose actual
    td = Td(1:3, 4);
    T = ur5FK(q);
    t = T(1:3, 4);
    e_p = td - t;
    
    % Complete el ciclo responsable de implementar el m�todo iterativo, 
    % seg�n el algoritmo descrito en la gu�a
    while((norm(e_p) > tol_p) && (k < K))
        T = ur5FK(q);
        t = T(1:3, 4);
        e_p = td - t;
        J = ur5J(q);
        Jv = J(1:3,:); % jacobiano de velocidad lineal

        % -----------------------------------------------------------------
        % El c�lculo de la inversa, la velocidad de reconfiguraci�n y el
        % algoritmo iterativo deben ir aqu�
        % -----------------------------------------------------------------
        % Se selecciona el m�todo para calcular la inversa del jacobiano
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
        
        % Se actualiza el algoritmo iterativo de cinem�tica inversa
        q = q + Ji*e_p; 
        
        k = k + 1; % Se incrementa el n�mero de iteraci�n
        Q(:,k+1) = q; % Se almacena la configuraci�n en el hist�rico
    end
    
    Q = Q(:,1:k+1); % Se extrae s�lo la parte del hist�rico que se emple�
end