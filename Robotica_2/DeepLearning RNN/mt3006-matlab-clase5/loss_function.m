function J = loss_function(X, y, w)
    n = size(X, 2);

    J = 0;
    
    % Se emplea una función de pérdida de error cuadrático
    for i = 1:n
        J = J + 0.5*( y(i) - hypothesis(X(:,i), w) )^2;
    end
end