% =========================================================================
% MT3006 - CLASE2: EJEMPLO DE FILTRADO LTI DE IMÁGENES
% =========================================================================
% En el siguiente ejemplo se emplean distintas funciones en MATLAB junto
% con distintos kernels para filtrar dos imágenes típicas. Comentar y
% descomentar para hacer pruebas.
% =========================================================================
%% Selección de imagen a cargar
% Lena:
I = imread('mandril_color.tif');
I = rgb2gray(I); % se pasa a escala de grises

% House:
% I = imread('house.tif');
% I = I(:,:,1);

%% Selección de kernel para filtrado (comentar y descomentar)
% h = (1/9) * ones(3, 3) % Box filter
% h = (1/16) * [1, 2, 1; 2, 4, 2; 1, 2, 1] % Gaussian kernel
% h = [1, 4, 6, 4, 1;
%     4, 16,  24,  16, 4;
%     6,  24,  36,  24, 6;
%     4,  16,  24,  16, 4;
%     1, 4, 6, 4, 1] * (1/256) % Large Gaussian kernel
% h = -ones(3, 3); h(2, 2) = 8; % Simple high-pass filter
% h = [-1, -1, -1, -1, -1;
%     -1,  1,  2,  1, -1;
%     -1,  2,  4,  2, -1;
%     -1,  1,  2,  1, -1;
%     -1, -1, -1, -1, -1] % Wide high-pass filter
% h = [-1, 0, 1; -1, 0, 1; -1, 0, 1] % Prewitt horizontal kernel
% h = [-1, -1, -1; 0, 0, 0; 1, 1, 1] % Prewitt vertical kernel
% h = [-1, 0, 1; -2, 0, 2; -1, 0, 1] % Sobel horizontal kernel
h = [-1, -2, -1; 0, 0, 0; 1, 2, 1] % Sobel vertical kernel

%% Formas equivalentes de implementar el filtrado
% J = conv2(I, h);
% J = xcorr2(I, h);
J = imfilter(I, h); % <-- mejor opción ya que normaliza el resultado

%% Se muestra tanto la imagen original como la filtrada
figure;
subplot(1, 2, 1);
imshow(I);
axis off;
axis square;
subplot(1, 2, 2);
imshow(J);
axis off;
axis square;