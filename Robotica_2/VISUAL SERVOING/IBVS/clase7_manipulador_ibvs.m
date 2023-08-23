% =========================================================================
% MT3006 - CLASE 7: EJEMPLO IBVS PARA MANIPULADOR SERIAL
% -------------------------------------------------------------------------
% Se presenta un ejemplo básico de visual servoing basado en imágenes para
% el manipulador UR5.
% =========================================================================
q0 = zeros(6,1); % pose inicial

point = [-0.5; -1; 0]; % punto deseado a rastrear
sd = [200; 200]; % posición deseada en el plano de imagen

% Se encuentra la secuencia de configuraciones necesarias según el problema
% de IBVS
[q, Q] = ur5IBVS(sd, q0, point); 

% Se grafican los resultados
figure;
plot(Q', 'LineWidth', 1); % trayectorias de la configuración
grid minor;

ur5Plot(Q, point); % vista del manipulador y la cámara
