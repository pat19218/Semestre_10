% Parámetros de la cámara
f = 0.015;
rhow = 10e-6;
rhoh = 10e-6;
fp = f/rhow;
u0 = 1024/2;
v0 = 1024/2;
% Matriz de parámetros intrínsecos
Kcam = [f/rhow,0,u0,0; 0,f/rhoh,v0,0; 0,0,1,0];

% Pose, orientación y jacobiano del efector final
BT_E = eye(4);
% Se calcula la matriz de la cámara según la pose del E.F.
C = Kcam*BT_E;

point = [0;0;0.5];

% Punto proyectado al plano de imagen
ls = C*[point;1]
% Puntos medidos por la cámara en pixeles
s = round(ls(1:2) / ls(3))

ubar = s(1) - u0
vbar = s(2) - v0
