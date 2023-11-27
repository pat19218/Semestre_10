%% Proyecto de mapeo mediante uso de OpenCamera y el Robotat

%pol = robotat_3pi_connect(6);
%robotat = robotat_connect();
rob = robotat_get_pose(robotat, 6, 'eulxyz'); %por ahora
obs0 = robotat_get_pose(robotat, 10, 'eulxyz'); %por ahora
obs1 = robotat_get_pose(robotat, 11, 'eulxyz'); %por ahora
obs2 = robotat_get_pose(robotat, 12, 'eulxyz'); %por ahora
obs3 = robotat_get_pose(robotat, 13, 'eulxyz'); %por ahora
tag = 0;

robotat_3pi_set_wheel_velocities(pol, 5, -5);

% para obstaculo 1
xhat1_prior = [0;0];
xhat1_post = [0;0];
P1_prior = 0.01*eye(2);
P1_post = 0.01*eye(2);
% para obstaculo 2
xhat2_prior = [0;0];
xhat2_post = [0;0];
P2_prior = 0.01*eye(2);
P2_post = 0.01*eye(2);
% para obstaculo 3
xhat3_prior = [0;0];
xhat3_post = [0;0];
P3_prior = 0.01*eye(2);
P3_post = 0.01*eye(2);
% para obstaculo 4
xhat4_prior = [0;0];
xhat4_post = [0;0];
P4_prior = 0.01*eye(2);
P4_post = 0.01*eye(2);

C = eye(2);
yk = [];
Lk = [];
mapa = zeros(2,4);
Qv = [1e-3,0;0,1e-3]; % varianza de proceso
fac = (0.5)/(7.445); % ajuste de transformación a metros de la camara

while 1
    obs = robotat_3pi_read_apriltag(pol);
    while obs.id ~= -1
        rob = robotat_get_pose(robotat, 6, 'eulxyz'); %por ahora
        PAtg_R = [rob(1)+obs.z*fac;rob(2)+(obs.x*fac)]; % posición obstaculo 
        switch (obs.id+1)                               % respecto al Optitrack
            case 1 % para Apriltag0
                % predicción 
                xhat1_prior = xhat1_post;
                P1_prior = P1_post;
                % corrección
                tag = robotat_get_pose(robotat, 10, 'eulxyz'); %por ahora
                yk = PAtg_R(1:2);
                Lk = P1_prior*C'*(Qv+C*P1_prior*C')^-1;
                xhat1_post = xhat1_prior + Lk*(yk-C*xhat1_prior);
                P1_post = P1_prior - Lk*C*P1_prior;
                mapa(:,obs.id+1) = xhat1_post; % guardo ubicacion en variable mapa
                break;
            case 2 % para Apriltag1
                % predicción 
                xhat2_prior = xhat2_post;
                P2_prior = P2_post;
                % corrección
                tag = robotat_get_pose(robotat, 11, 'eulxyz'); %por ahora
                yk = PAtg_R(1:2);
                Lk = P2_prior*C'*(Qv+C*P2_prior*C')^-1;
                xhat2_post = xhat2_prior + Lk*(yk-C*xhat2_prior);
                P2_post = P2_prior - Lk*C*P2_prior;
                mapa(:,obs.id+1) = xhat2_post; % guardo ubicacion en variable mapa
                break;
            case 3 % para Apriltag2
                % predicción 
                xhat3_prior = xhat3_post;
                P3_prior = P3_post;
                % corrección
                tag = robotat_get_pose(robotat, 12, 'eulxyz'); %por ahora
                yk = PAtg_R(1:2);
                Lk = P3_prior*C'*(Qv+C*P3_prior*C')^-1;
                xhat3_post = xhat3_prior + Lk*(yk-C*xhat3_prior);
                P3_post = P3_prior - Lk*C*P3_prior;
                mapa(:,obs.id+1) = xhat3_post; % guardo ubicacion en variable mapa
                break;
             case 4 % para Apriltag4
                % predicción 
                xhat4_prior = xhat4_post;
                P4_prior = P4_post;
                % corrección
                tag = robotat_get_pose(robotat, 13, 'eulxyz'); %por ahora
                yk = PAtg_R(1:2);
                Lk = P4_prior*C'*(Qv+C*P4_prior*C')^-1;
                xhat4_post = xhat4_prior + Lk*(yk-C*xhat4_prior);
                P4_post = P4_prior - Lk*C*P4_prior;
                mapa(:,obs.id+1) = xhat4_post; % guardo ubicacion en variable mapa
                break;        
        end
    end
    figure(1); % graficando el proceso de mapeo en cada ciclo
    hold on;
    tag0 = scatter(obs0(1),obs0(2),'red');
    tag1 = scatter(obs1(1),obs1(2),'red'); % para ubicarión real 
    tag2 = scatter(obs2(1),obs2(2),'red');
    tag3 = scatter(obs3(1),obs3(2),'red');
    tag0_pred = scatter(mapa(1,1),mapa(2,1),'green','d');
    tag1_pred = scatter(mapa(1,2),mapa(2,2),'green','d'); % estimación de mapeo
    tag2_pred = scatter(mapa(1,3),mapa(2,3),'green','d');
    tag3_pred = scatter(mapa(1,4),mapa(2,4),'green','d');
    axis([-3.8/2 3.8/2 -4.8/2 4.8/2]);
    hold off;
end