function yi_hat = hypothesis(xi, w)
    % Perceptrón simple con función de activación sigmoide
    yi_hat = activation_function(w.'*[1;xi]);
end