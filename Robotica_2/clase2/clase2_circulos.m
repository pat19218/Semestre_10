% =========================================================================
% MT3006 - CLASE 2: EJEMPLO TRANSFORMADA DE HOUGH PARA CÍRCULOS
% =========================================================================
% En el siguiente ejemplo se emplea la función imfindcircles para
% determinar el radio y el centro de todos los círculos que puedan
% encontrarse en la imagen empleando la transformada de Hough.
% =========================================================================
% Se carga una imagen correspondiente a un grupo de monedas y se visualiza
A = imread('coins.png');
figure;
imshow(A);

% Se obtienen los centros y los radios de los círculos (en pixeles)
[centers, radii, metric] = imfindcircles(A,[15 30]);

% Se emplea la información obtenida de los círculos para mostrar un
% overlay sobre la imagen original que muestre los círculos encontrados
centersStrong5 = centers(1:5,:); 
radiiStrong5 = radii(1:5);
metricStrong5 = metric(1:5);
viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');