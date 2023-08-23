% =========================================================================
% MT3006 - EJEMPLO IBVS
% -------------------------------------------------------------------------
% A continuaci�n se muestra la implementaci�n del algoritmo de visual
% servoing basado en im�genes, asumiendo que puede medirse la profundidad
% del punto a rastrear.
% =========================================================================
function [q,Q] = ur5IBVS(sd, q0, point)
    tol_p = 1e-06; % Tolerancia del error
    % N�mero m�ximo de iteraciones (reducir en caso de mala performance 
    % durante la simulaci�n)
    K = 2000; 
    
    % Inicializaci�n de variables
    q = q0;
    n = numel(q);
    Q = zeros(n, K);
    Q(:,1) = q; 
    k = 0;
    
    % Par�metros de la c�mara
    f = 0.015;
    rhow = 1e-5;
    rhoh = 1e-5;
    u0 = 2*1024/2;
    v0 = 2*1024/2;
    fp = f/rhow;
    % Matriz de par�metros intr�nsecos
    Kcam = [f/rhow,0,u0,0; 0,f/rhoh,v0,0; 0,0,1,0];
    
    %% Inicializaci�n
    % Pose, orientaci�n y jacobiano del efector final
    BT_E = ur5FK(q);
    % Se calcula la matriz de la c�mara seg�n la pose del E.F.
    C = Kcam*BT_E^(-1);
    % Punto proyectado al plano de imagen
    ls = C*[point;1];
    % Puntos medidos por la c�mara en pixeles
    s = round(ls(1:2) / ls(3));
    % Se ajustan los puntos para referenciarlos con respecto a (u0,v0)
    s = s - [u0; v0];
        
    % Error inicial en el plano de imagen
    e_s = sd - s;
    
    %% Algoritmo recursivo para IBVS
    % Complete el ciclo responsable de implementar el m�todo iterativo, 
    % seg�n el algoritmo descrito en la gu�a
    while((norm(e_s) > tol_p) && (k < K))
        % Pose, orientaci�n y jacobiano del efector final
        BT_E = ur5FK(q);
        BR_E = BT_E(1:3,1:3);
        J = ur5J(q);
        
        % Se calcula la matriz de la c�mara seg�n la pose del E.F.
        C = Kcam*BT_E^(-1);
        % Punto proyectado al plano de imagen
        ls = C*[point;1];
        % Puntos medidos por la c�mara en pixeles
        s = round(ls(1:2) / ls(3));
        % Se ajustan los puntos para referenciarlos con respecto a (u0,v0)
        s = s - [u0; v0];
        % Profundidad real del punto
        lambda = ls(3);
        
        % Error en el plano de imagen
        e_s = sd - s;
       
        % Informaci�n del punto en el plano de imagen para el IBVS
        ubar = s(1);
        vbar = s(2);
        
        % Se calcula la matriz de interacci�n y el jacobiano de imagen
        Lp = [-fp/lambda, 0, ubar/lambda, ubar*vbar/fp, -(fp^2+ubar^2)/fp, vbar; 
              0, -fp/lambda, vbar/lambda, (fp^2+vbar^2)/fp, -ubar*vbar/fp, -ubar];
        EJ = [BR_E', eye(3); eye(3), BR_E']*J;
        JL = Lp*EJ;  
        
        % Se selecciona el m�todo para calcular la inversa del jacobiano
        invsel = 'pseudoinversa';
        
        switch invsel
            case 'pseudoinversa'
                Ji = pinv(JL);
            case 'traspuesta'
%                 alpha = (e_s'*(JL*JL')*e_s) / (e_s'*(JL*JL')*(JL*JL')*e_s);
                alpha = 1e-6*0.05;
                Ji = alpha*JL'; 
            case 'levenberg'
                Ji = JL'/(JL*JL'+(0.1)^2*eye(min(size(JL))));
            otherwise
                Ji = pinv(JL);
        end
        
        % Se actualiza el algoritmo de IBVS
        q = q + 0.1*Ji*e_s; 
        
        k = k + 1; % Se incrementa el n�mero de iteraci�n
        Q(:,k+1) = q; % Se almacena la configuraci�n en el hist�rico
    end
    
    Q = Q(:,1:k+1); % Se extrae s�lo la parte del hist�rico que se emple�
end