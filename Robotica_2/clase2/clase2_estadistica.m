% =========================================================================
% MT3006 - CLASE 2: EJEMPLO DE OPERACIONES BINARIAS Y ESTADÍSTICAS CON EL 
% TOOLBOX
% =========================================================================
% En el siguiente ejemplo se emplean algunas de las funciones del Toolbox
% de Machine Vision de Peter Corke para efectuar operaciones estadísticas y
% binarias (thresholding) sobre imágenes de prueba. Se comparan algunas
% funciones con sus equivalentes en MATLAB.
% ***OJO*** Debe instalarse primero la Machine Vision Toolbox de Peter
% Corke antes de correr estos ejemplos. Esta puede descargarse aquí:
% https://petercorke.com/toolboxes/machine-vision-toolbox/
% =========================================================================
% Lectura y despliegue de imágenes (Toolbox)
I1 = iread('church.png', 'grey'); % Con opción de pasar a escala de grises
I1 = imresize(I1, 0.5); % Se reduce el tamaño de la imagen a la mitad
figure;
idisp(I1);

% Lectura y despliegue de imágenes (Matlab)
I2 = imread('chess_circles.jpg');
I2 = imresize(I2, 0.5); % Se reduce el tamaño de la imagen a la mitad
I2g = rgb2gray(I2); % Se convierte a escala de grises
I2hsi = rgb2hsv(I2); % Se convierte al espacio de color HSV
figure;
imshow(I2g);

%% Ejemplos de procesamiento
% J1 = (I1 >= 180); % Tresholding
% ithresh(I1)

% J1 = inormhist(I1); % Normalización de histograma
% J1 = igamm(I1, 1/0.45); % Decodificación gamma
J1 = (I1/64)*(255/3);% Posterización

%% Se despliega el histograma de la imagen original y luego de ser procesada
figure;
subplot(1,2,1);
ihist(I1);
%ihist(I1, 'cdf'); % La opción 'cdf' muestra el histograma acumulado
subplot(1,2,2);
ihist(J1, 'cdf');

%% Se despliega la imagen original y luego de ser procesada
figure;
subplot(1,2,1);
imshow(I1);
subplot(1,2,2);
imshow(J1);
