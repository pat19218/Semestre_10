% =========================================================================
% MT3006 - CLASE2: EJEMPLO SEGMENTACIÓN
% =========================================================================
% En el siguiente ejemplo se muestra como puede emplearse la función
% regionprops para determinar la posición y orientación de objetos
% empleando una aproximación mediante elipses. Luego se visualizan estos
% elipses en un overlay sobre la imagen original.
% =========================================================================
% Se carga una imagen correspondiente a un grupo de granos de arroz y se
% visualiza
bw = imread('rice_binary.png');
imshow(bw);
hold on;

% Se emplea regionprops para segmentación, obteniendo la posición y
% orientación de todos los elipses que representan a cada uno de los
% objetos encontrados
s = regionprops(bw, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid')

% Se grafica el overlay sobre la imagen original en donde se muestren los
% elipses encontrados mediante segmentación
phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

for k = 1:length(s)
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    theta = pi*s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [a*cosphi; b*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;

    plot(x,y,'r','LineWidth',2);
end
hold off;
