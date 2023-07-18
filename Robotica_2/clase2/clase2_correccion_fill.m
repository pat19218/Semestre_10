% =========================================================================
% MT3006 - CLASE 3: EJEMPLO CORRECCI�N POR RELLENADO DE IM�GENES
% =========================================================================
% En el siguiente ejemplo se muestra como puede emplearse la funci�n fill
% de llenado para mejorar los resultados de una operaci�n de thresholding.
% =========================================================================
% Se carga una imagen correspondiente a un grupo de monedas y se visualiza
I = imread('coins.png');
figure;
subplot(1,3,1);
imshow(I);
title('Imagen original');

% Se efect�a la operaci�n de thresholding
BW = imbinarize(I);
subplot(1,3,2);
imshow(BW);
title('Imagen original convertida a binario');

% Se emplea la funci�n fill para rellenar los agujeros luego de la
% binarizaci�n
BW2 = imfill(BW, 'holes');
subplot(1,3,3);
imshow(BW2);
title('Imagen rellenada');

% Se verifica que ahora ya pueda efectuarse segmentaci�n adecuadamente
s = regionprops(BW2, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid')