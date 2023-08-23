% =========================================================================
% MT3006 - CLASE 7: EJEMPLO IBVS PARA MANIPULADOR SERIAL
% -------------------------------------------------------------------------
% Se presenta un ejemplo b�sico de visual servoing basado en im�genes para
% el manipulador UR5.
% =========================================================================
q0 = zeros(6,1); % pose inicial

point = [-0.5; -1; 0]; % punto deseado a rastrear
sd = [200; 200]; % posici�n deseada en el plano de imagen

% Se encuentra la secuencia de configuraciones necesarias seg�n el problema
% de IBVS
[q, Q] = ur5IBVS(sd, q0, point); 

% Se grafican los resultados
figure;
plot(Q', 'LineWidth', 1); % trayectorias de la configuraci�n
grid minor;

ur5Plot(Q, point); % vista del manipulador y la c�mara
