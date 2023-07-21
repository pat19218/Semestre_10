%% ========================================================================
%                         Laboratorio 2 parte I
% =========================================================================
%  Curso:   Robotica 2
%  Nombre:  Cristhofer Patzán
%  Carné:   19219
%  Detectar los colores 
% 
clear;clc;

%% ========================================================================
%                            Cargar imagen
% =========================================================================

A = imread('res4.jpeg');
%figure;
%imshow(A);

%% ========================================================================
%                               Mascaras
% =========================================================================

% Primer mascara (rojo)
[BW1,maskek_red] = mask_red(A);

% Segunda mascara (morado)
[BW2,maskek_purple] = mask_purple(A);

% Tercer mascara (amarillo)
[BW3,maskek_yellow] = mask_yellow(A);   

figure;
subplot(1,4,1);
    imshow(A);
    title('Original');
subplot(1,4,2);
    imshow(maskek_red);
    title('Rojo');
subplot(1,4,3);
    imshow(maskek_purple);
    title('Morado');
subplot(1,4,4);
    imshow(maskek_yellow);
    title('Amarillo');

%% ========================================================================
%                           Negativos imfill
% =========================================================================

BW1fill = imfill(BW1, 8,'holes');
BW2fill = imfill(BW2, 8, 'holes');
BW3fill = imfill(BW3, 8, "holes");

% figure;
% subplot(1,2,1)
% imshow(BW1fill)
% title('Filled Image')
% subplot(1,2,2)
% imshow(BW1)

%% ========================================================================
%                               Segmentacion
% =========================================================================

%------------------------------- rojo -------------------------------------

BW_out_red = BW1fill;

% Filter image based on image properties.
BW_out_red = bwpropfilt(BW_out_red,'Area',[40, 8047]);

% Get properties.
properties_red = regionprops(BW_out_red, {'Area', 'Eccentricity', 'EquivDiameter',...
    'EulerNumber', 'MajorAxisLength', 'MinorAxisLength', 'Orientation',...
    'Perimeter', 'Centroid'});

%----------------------------- morado -------------------------------------

BW_out_purple = BW2fill;

% Filter image based on image properties.
BW_out_purple = bwpropfilt(BW_out_purple,'Area',[1050, 8047]);

% Get properties.
properties_purple = regionprops(BW_out_purple, {'Area', 'Eccentricity', 'EquivDiameter',...
    'EulerNumber', 'MajorAxisLength', 'MinorAxisLength', 'Orientation',...
    'Perimeter', 'Centroid'});

chage_siza = isempty(properties_purple);

if chage_siza
    %disp('si estaba vacio')
    % Filter image based on image properties.
    BW_out_purple = bwpropfilt(BW2fill,'Area',[107, 8047]);

    % Get properties.
    properties_purple = regionprops(BW_out_purple, {'Area', 'Eccentricity', 'EquivDiameter',...
    'EulerNumber', 'MajorAxisLength', 'MinorAxisLength', 'Orientation',...
    'Perimeter', 'Centroid'});

    %disp(properties_purple)

end

%------------------------ amarillo ----------------------------------------

BW_out_yellow = BW3fill;

% Filter image based on image properties.
BW_out_yellow = bwpropfilt(BW_out_yellow,'Area',[381, 8047]);

% Get properties.
properties_yellow = regionprops(BW_out_yellow, {'Area', 'Eccentricity', 'EquivDiameter',...
    'EulerNumber', 'MajorAxisLength', 'MinorAxisLength', 'Orientation',...
    'Perimeter', 'Centroid'});

%% ========================================================================
%                         Distancias absolutas
% =========================================================================

try
    yellow_purple_x = abs(properties_yellow.Centroid(1)-properties_purple.Centroid(1));
    yellow_red_x = abs(properties_yellow.Centroid(1)-properties_red.Centroid(1));
    
    
    if yellow_red_x > yellow_purple_x
        disp('Si es una resistencia de 4.7 kΩ')
    else
        disp('No es una resistencia de 4.7 kΩ')
    end
catch   
    disp('No es una resistencia de 4.7 kΩ')
end

