%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Algoritmo Batch Perceptron
%  Luis Alberto Rivera

% Entradas: Y - matriz con las muestras aumentadas y "normalizadas" como vectores columna
%         eta - tasa de aprendizaje (constante)
%          th - umbral para detener el algoritmo
%        kmax - número máximo de iteraciones
%          op - opción para ir mostrando los resultados parciales o no. Si op = 0, no se
%               muestran los datos. Si op > 1, se muestran los datos en la figura número
%               op (debe ser número entero). Esta opción se ignora si la dimensionalidad
%               de los datos no es 2 ó 3.

% Salidas:  a - Vector de pesos (vector columna)
%           k - número de iteraciones que se necesitaron
function [a, k] = batch_perceptron(Y, eta, th, kmax, op)
% inicializaciones
k = 0;
d = size(Y,1);
% a = zeros(d,1);
a = 2*rand(d,1)-1;  % aleatorios entre -1 y 1
cambio = inf;

if(d < 3 || d > 4)
    op = 0;  % Graficar sólo si los datos (originales) son bi o tridimensionales
end

if(op ~= 0)
    figure(op); clf;    % Para limpiar la figura
    syms x1 x2 x3
    x = [x1;x2;x3];
    c1_ind = Y(1,:) == 1;
    X1 = Y(2:d,c1_ind);
    X2 = -Y(2:d,~c1_ind);
    Xall = [X1,X2];
    xmin = min(Xall(1,:));
    xmax = max(Xall(1,:));
    ymin = min(Xall(2,:));
    ymax = max(Xall(2,:));
    if(d == 4)
        zmin = min(Xall(3,:));
        zmax = max(Xall(3,:));
    end
end

% continuar mientras no se cumplan los criterios de terminación
while((cambio > th) && (k < kmax))
    k = k + 1;
    clasif = a'*Y;
    Yerror = Y(:,clasif<=0);    % "Y chilerosa"
    a = a + eta*sum(Yerror,2);
    cambio = norm(eta*sum(Yerror,2));
    
    if(op ~= 0)
        figure(op);
        hold off;
        g_a = a(1) + a(2:end)'*x(1:(length(a)-1));  % w0 + w1*x1 + w2*x2 + w3*x3
                
        if(d == 3)
            scatter(X1(1,:),X1(2,:),'b','filled');
            hold on;
            scatter(X2(1,:),X2(2,:),'r','filled');
            fimplicit(g_a,[xmin xmax ymin ymax]);
            xlabel('x'); ylabel('y');
        else
            scatter3(X1(1,:),X1(2,:),X1(3,:),'b','filled');
            hold on;
            scatter3(X2(1,:),X2(2,:),X2(3,:),'r','filled');
            fimplicit3(g_a,[xmin xmax ymin ymax zmin zmax]);
            xlabel('x'); ylabel('y'); zlabel('z');
        end

        legend('C1','C2','frontera');
        title(['Iteración: ', num2str(k), ' Diferencia: ', num2str(cambio)]);
        pause(0.01);
    end
end

end
