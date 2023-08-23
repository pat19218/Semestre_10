function h = ur5Plot(Q, goal)  
    [n, K] = size(Q); 
    
    P = zeros(3, n+1);
    P(:,1) = [0;0;0];
    A = genDHmatrix(0, 0, 0, 0);
    
    DH = [ 0, 0.089459,        0,  1.5708; 
           0,        0,   -0.425,       0; 
           0,        0, -0.39225,       0; 
           0,  0.10915,        0,  1.5708; 
           0,  0.09465,        0, -1.5708; 
           0,   0.0823,        0,       0];
    
    % Definición de la cámara
    f = 0.015;
    rhow = 1e-5;
    rhoh = 1e-5;
    u0 = 2*1024/2;
    v0 = 2*1024/2;

    Kcam = [f/rhow,0,u0,0; 0,f/rhoh,v0,0; 0,0,1,0];
    
    % Se calcula la matriz de la cámara según la pose del E.F.
    C = Kcam*ur5FK(Q(:,1))^(-1);

    % Punto proyectado al plano de imagen
    ls1 = C*[goal;1];

    % Puntos medidos por la cámara en pixeles
    s1 = round(ls1(1:2) / ls1(3));
    % Se ajustan los puntos para referenciarlos con respecto a (u0,v0)
    s1 = s1 - [u0; v0];
       
    for i = 1:n
        A = A*genDHmatrix(Q(i,1), DH(i,2), DH(i,3), DH(i,4));
        P(:,i+1) = A(1:3,4);
    end
     
    figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    subplot(1,2,1);
    scatter3(goal(1), goal(2), goal(3), 50, 'r', 'filled');
    hold on;
    h = plot3(P(1,:), P(2,:), P(3,:), 'Color', [0.3, 0.3, 0.3], 'LineWidth', 5); %'k', 'LineWidth', 5);
    hold off;
    xlim([-1,1]);
    ylim([-1,1]);
    zlim([-1,1]);
    axis('square');
    grid minor;
    title('Vista manipulador');
    
    subplot(1,2,2);
    camres = 1024/2;
    line([0,0], 2*[-camres,camres], 'Color','k'); 
    hold on;
    line(2*[-camres,camres], [0,0], 'Color','k');
    h2 = scatter(s1(1), s1(2), 50, 'r', 'filled');
    hold off;
    xlim(2*[-camres,camres]);
    ylim(2*[-camres,camres]);
    axis('square');
    grid minor;
    title('Vista cámara');
    
    if(K > 1)
        for k = 2:K
            P = zeros(3, n+1);
            P(:,1) = [0;0;0];
            A = genDHmatrix(0, 0, 0, 0);
            
            %% Cámara
            % Se calcula la matriz de la cámara según la pose del E.F.
            C = Kcam*ur5FK(Q(:,k))^(-1);

            % Punto proyectado al plano de imagen
            ls1 = C*[goal;1];

            % Puntos medidos por la cámara en pixeles
            s1 = round(ls1(1:2) / ls1(3));
            % Se ajustan los puntos para referenciarlos con respecto a (u0,v0)
            s1 = s1 - [u0; v0];
            
            %% Manipulador
            for i = 1:n
                A = A*genDHmatrix(Q(i,k), DH(i,2), DH(i,3), DH(i,4));
                P(:,i+1) = A(1:3,4);
            end
            
            h.XData = P(1,:);
            h.YData = P(2,:);
            h.ZData = P(3,:);
            
            h2.XData = s1(1);
            h2.YData = s1(2);
            dt = 0.01;
            pause(dt);
        end
    end
end