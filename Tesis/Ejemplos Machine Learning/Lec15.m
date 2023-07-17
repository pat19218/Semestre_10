%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 15
%  Luis Alberto Rivera

%% Antes de correr el programa, asegúrese de descargar el archivo L15_datos.mat
%%

load L15_datos.mat  % Cargar las muestras

% Gráfica de muestras originales
figure(1); clf;
scatter3(X1(:,1),X1(:,2),X1(:,3),'b');
hold on;
scatter3(X2(:,1),X2(:,2),X2(:,3),'r');
scatter3(X3(:,1),X3(:,2),X3(:,3),'g');
grid on;
xlabel('x1'); ylabel('x2'); zlabel('x3');
legend('Clase 1','Clase 2','Clase 3');
title('Muestras Originales');

%% Cálculos
n1 = size(X1,1); n2 = size(X2,1); n3 = size(X3,1);
n = n1 + n2 + n3;

% Medias
m1 = mean(X1);
m2 = mean(X2);
m3 = mean(X3);
m = mean([X1;X2;X3]);   % lo mismo que  m = (1/n)*(n1*m1 + n2*m2 + n3*m3)

% Matrices de Dispersión
S1 = (n1-1)*cov(X1);
S2 = (n2-1)*cov(X2);
S3 = (n3-1)*cov(X3);
SW = S1 + S2 + S3;
% Notar que los vectores son filas, por lo que las fórmulas se deben ajustar
SB = n1*(m1-m)'*(m1-m) + n2*(m2-m)'*(m2-m) + n3*(m3-m)'*(m3-m);
ST = SW + SB;

rango = rank(SB);   % Se espera que sea c-1
fprintf('Rango de SB = %d\n\n', rango);

if(det(SW) ~= 0)
    [Phi,Lambda] = eig(SW\SB); % SW\SB = inv(SW)*SB  (más eficiente)
    
    % Sólo queremos "rango" número de vectores w. Podríamos comparar los valores del
    % vector diag(Lambda) con cero, y tomar los eigenvectores
    % correspondientes a los eigenvalores distintos de cero. Sin embargo,
    % por aproximaciones numéricas, los eigenvalores en Lambda que teóricamente
    % deberían ser cero, pueden no ser exactamente cero (serían valores muy
    % pequeños). Por ello, ordenamos los eigenvalores en forma
    % descendente, y tomamos los primeros "rango" eigenvectores
    % correspondientes.
    [~,indices] = sort(diag(Lambda),'descend');  % índices ordenados
    W = Phi(:,indices(1:rango));
        
    Y1 = (W'*X1')';     % Recordar que X1, X2 y X3 tienen vectores fila
    Y2 = (W'*X2')';     % Dejamos Y1, Y2 y Y3 también con vectores fila,
    Y3 = (W'*X3')';     % para consistencia con las Xs (no es necesario)
    
    % Proyección sobre el plano definido por los vectores de W
    figure(2); clf;
    scatter(Y1(:,1),Y1(:,2),'b');
    hold on;
    scatter(Y2(:,1),Y2(:,2),'r');
    scatter(Y3(:,1),Y3(:,2),'g');
    grid on;
    xlabel('w1'); ylabel('w2');
    legend('Clase 1','Clase 2','Clase 3');
    title('Proyección sobre el plano definido por W');
    
    % Proyección sobre el plano x1-x2
    figure(3); clf;
    scatter(X1(:,1),X1(:,2),'b');
    hold on;
    scatter(X2(:,1),X2(:,2),'r');
    scatter(X3(:,1),X3(:,2),'g');
    grid on;
    xlabel('x1'); ylabel('x2');
    legend('Clase 1','Clase 2','Clase 3');
    title('Proyección sobre el plano x1-x2');
    % Notar que sería lo mismo proyectar los puntos usando la matriz [1 0;0 1;0 0]
    
    % Haga usted las proyecciones sobre los planos x1-x3 y x2-x3
    
    % Proyección sobre un plano arbitrario
    warb1 = [8,-3,5]';
    warb1 = warb1/norm(warb1);  % normaliza el vector
    warb2 = [-8,-5,0]';
    warb2 = warb2/norm(warb2);  % normaliza el vector.
    
    Arb = [warb1,warb2];
    Y1arb = (Arb'*X1')';    % Recordar que X1, X2 y X3 tienen vectores fila
    Y2arb = (Arb'*X2')';
    Y3arb = (Arb'*X3')';
    
    figure(4); clf;
    scatter(Y1arb(:,1),Y1arb(:,2),'b');
    hold on;
    scatter(Y2arb(:,1),Y2arb(:,2),'r');
    scatter(Y3arb(:,1),Y3arb(:,2),'g');
    grid on;
    xlabel('arb1'); ylabel('arb2');
    legend('Clase 1','Clase 2','Clase 3');
    title('Proyección sobre un plano arbitrario');
end

% Probar calcular los vecotres de W sin calcular la inversa de SW, como se
% menciona en la página 9 de la Lección 15.
% Eso sería necesario si SW es singular.
% Aunque SW fuese invertible, no tener que calcular la inversa de SW sería
% conveniente (computacionalmente hablando), si la dimensionalidad de los
% datos fuese grande.
