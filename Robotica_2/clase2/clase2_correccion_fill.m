% =========================================================================
% MT3006 - CLASE 3: EJEMPLO CORRECCIÓN POR RELLENADO DE IMÁGENES
% =========================================================================
% En el siguiente ejemplo se muestra como puede emplearse la función fill
% de llenado para mejorar los resultados de una operación de thresholding.
% =========================================================================
% Se carga una imagen correspondiente a un grupo de monedas y se visualiza
I = imread('coins.png');
figure;
subplot(1,3,1);
imshow(I);
title('Imagen original');

% Se efectúa la operación de thresholding
BW = imbinarize(I);
subplot(1,3,2);
imshow(BW);
title('Imagen original convertida a binario');

% Se emplea la función fill para rellenar los agujeros luego de la
% binarización
BW2 = imfill(BW, 'holes');
subplot(1,3,3);
imshow(BW2);
title('Imagen rellenada');

% Se verifica que ahora ya pueda efectuarse segmentación adecuadamente
s = regionprops(BW2, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid')