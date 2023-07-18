% =========================================================================
% MT3006 - CLASE 2: EJEMPLO TRANSFORMADA DE HOUGH PARA C�RCULOS
% =========================================================================
% En el siguiente ejemplo se emplea la funci�n imfindcircles para
% determinar el radio y el centro de todos los c�rculos que puedan
% encontrarse en la imagen empleando la transformada de Hough.
% =========================================================================
% Se carga una imagen correspondiente a un grupo de monedas y se visualiza
A = imread('coins.png');
figure;
imshow(A);

% Se obtienen los centros y los radios de los c�rculos (en pixeles)
[centers, radii, metric] = imfindcircles(A,[15 30]);

% Se emplea la informaci�n obtenida de los c�rculos para mostrar un
% overlay sobre la imagen original que muestre los c�rculos encontrados
centersStrong5 = centers(1:5,:); 
radiiStrong5 = radii(1:5);
metricStrong5 = metric(1:5);
viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');