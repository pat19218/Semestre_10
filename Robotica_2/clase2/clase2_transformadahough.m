% =========================================================================
% MT3006 - CLASE 2: EJEMPLO TRANSFORMADA DE HOUGH PARA LÍNEAS
% =========================================================================
% En el siguiente ejemplo se emplea la función hough para determinar las 
% líneas presentes en la imagen. Luego se muestra un overlay de las mismas
% sobre la imagen original.
% =========================================================================
% Se carga una imagen correspondiente a un tablero de ajedrez
I = imread('chess_circles.jpg');

% Se reduce en un 50%
I = imresize(I, 0.5);

% Se convierte a escala de grises
Ig = rgb2gray(I);

% Se obtiene un kernel Gaussiano para suavizado
K = fspecial('gaussian');

% Se suaviza la imagen. Nótese que múltiples pasadas del kernel equivalen a
% aplicar una única pasada de un kernel más grande (filtros en cascada)
Igf = imfilter(Ig, K);
Igf = imfilter(Igf, K);
Igf = imfilter(Igf, K);

% Se obtienen los bordes empleando el detector Canny
E = edge(Ig, 'canny');

% Se efectúa la transformada de Hough para líneas
[H, T, R] = hough(E);

% Se extraen los top N candidatos de líneas desde el acumulador 
N = 10;
P = houghpeaks(H, N);

% Se obtienen los parámetros para estas líneas
lines = houghlines(Igf, T, R, P);

% Se muestran las líneas en un overlay sobre la imagen original, además se
% despliega el espacio Hough
figure;
subplot(2, 1, 1);
imshow(I);
title('chess\_circles.jpg');
hold on;

% Se colocan las líneas detectadas en el overlay
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'blue');

   % Se grafican los inicios y finales de las líneas
   plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
   plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');
end

% Se muestra el espacio Hough
subplot(2, 1, 2);
imshow(imadjust(mat2gray(H)), 'XData', T, 'YData', R, 'InitialMagnification', 'fit');
title('Hough Line Transform');
xlabel('\theta');
ylabel('\rho');
axis on;
axis normal;
grid on;
hold on;

% Se despliega como un mapa de color
colormap('jet');