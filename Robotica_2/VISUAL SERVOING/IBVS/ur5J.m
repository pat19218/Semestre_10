function J = ur5J(q)
    % El argumento q es el vector de configuración, asuma que está dado por
    % un vector columna q = [q1 q2 q3 q4 q5 q6 q7 q8 q9 q10]'.
    
    % Dimensión de la configuración del manipulador redundante
    n = numel(q);
    delta = 0.00001;
    
    T = ur5FK(q); 
    R = T(1:3, 1:3);
    
    % Inicialización del jacobiano
    J = zeros(6, n);
    
    for j = 1:n
        e = zeros(n, 1);
        e(j) = delta;
        
        dKdqj = (ur5FK(q+e) - T) / delta;
        dtdqj = dKdqj(1:3,end);
        dRdqj = dKdqj(1:3,1:3);
        S = dRdqj*R.';
        dthetadqj = vex(S);
        
        J(:, j) = [dtdqj; dthetadqj];
    end
end 