%% Laboratorio 2 parte I
%  Curso:   Robotica 2
%  Nombre:  Cristhofer Patzán
%  Carné:   19219
%  Detectar los colores 
% 
clear;clc;

%% Cargar imagen
A = imread('res1.jpeg');
%figure;
%imshow(A);

%% Mascaras
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

%% Negativos imfill
BW1fill = imfill(BW1,'holes');
BW2fill = imfill(BW2, 'holes');
BW3fill = imfill(BW3, "holes");

% figure;
% subplot(1,2,1)
% imshow(BW3fill)
% title('Filled Image')
% subplot(1,2,2)
% imshow(BW3)

%% Segmentacion




