%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 7 - Ejercicio 2
%  Luis Alberto Rivera

%% Distribución Original
mu = [0;0];
Sig = [3 0;0 1];

maxSig = max(diag(sqrt(Sig)));
N = 50; % número de puntos por dimensión

% Coordenadas x1 y x2 a usar
x1 = linspace(mu(1)-2.5*maxSig,mu(1)+2.5*maxSig,N);
x2 = linspace(mu(2)-2.5*maxSig,mu(2)+2.5*maxSig,N);
[X1,X2] = meshgrid(x1,x2);  % crea el "grid" de puntos a evaluar
X1_columna = reshape(X1,[],1);  % vector columna con todas las coordenadas x1 del grid
X2_columna = reshape(X2,[],1);  % vector columna con todas las coordenadas x2 del grid
X_todos = [X1_columna,X2_columna];  % Todos los vectores (fila) en una matriz
Z_todos = mvnpdf(X_todos,mu',Sig);  % Todas las imágenes de los vectores X_todos
pdf = reshape(Z_todos,size(X1,1),[]); % Para que coincidan con las matrices X1 y X2

screensize = get(groot, 'Screensize');  % Obtiene el tamaño del monitor
h0 = figure(10); clf;
% Lo siguiente es para que la figura tenga un tamaño específico.
% Para ello, se necesita el "handler" de la figura (h0).
set(h0, 'OuterPosition',[0, screensize(4)/6, screensize(3), 5*screensize(4)/6]);
subplot(1,2,1);
surf(X1,X2,pdf);
xlabel('x1'); ylabel('x2'); zlabel('pdf');
title('Densidad');
subplot(1,2,2);
contour(X1,X2,pdf);
grid on;
xlabel('x1'); ylabel('x2');
title('Contornos');
sgtitle('Distribución Original');


%% Transformaciones 2x2
theta = 30*pi/180;
A2 = [cos(theta) -sin(theta); sin(theta) cos(theta)];
N = 50;

% Llamado a la función L7_ej2_fun
[muT2,SigT2,X1_2,X2_2,pdf2] = L7_ej2_fun(mu,Sig,A2,N);

h2 = figure(2); clf;
set(h2, 'OuterPosition',[0, screensize(4)/12, screensize(3), 5*screensize(4)/6]);
subplot(1,2,1);
surf(X1_2,X2_2,pdf2);
xlabel('x1'); ylabel('x2'); zlabel('pdf');
title('Densidad');
subplot(1,2,2);
contour(X1_2,X2_2,pdf2);
grid on;
xlabel('x1'); ylabel('x2');
title('Contornos');
sgtitle('Distribución Transformada');


%% Transformaciones 2x1
A1 = [0;1];
N = 200;

% Llamado a la función L7_ej2_fun. Note que la penúltima variable de salida
% no es relevante, por lo que se puede colocar un '~'.
[muT1,SigT1,X1_1,~,pdf1] = L7_ej2_fun(mu,Sig,A1,N);

h1 = figure(1); clf;
plot(X1_1,pdf1);
grid on;
xlabel('x'); ylabel('y');
title('Distribución Transformada');


