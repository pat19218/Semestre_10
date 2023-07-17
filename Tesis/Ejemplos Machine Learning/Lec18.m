%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 18
%  Luis Alberto Rivera

%% Ejemplo
b1 = [3.1 13.7 -4.5 8.6]';   
Y1 = [1 2;1 4;1 1;1 3];

PseudoI1 = (Y1'*Y1)\Y1';
a1 = PseudoI1*b1   % a = [c, m]
syms x
y1 = a1(2)*x + a1(1);

figure(1); clf;
scatter(Y1(:,2),b1,'filled');
hold on;
fplot(y1,'k');
grid on;
xlim([0,5]);
ylim([-5,15]);

%% Ejercicio
Xc1 = [1 2;2 0];    Xc2 = [2 3;3 1];
Y = [[ones(2,1),Xc1];-[ones(2,1),Xc2]]; % "Normalizar" las muestras de la clase 2
b_1 = ones(4,1);
b_2 = (1:4)';
b_3 = rand(4,1);

PseudoI = (Y'*Y)\Y';
a_1 = PseudoI*b_1;  % a = [w0 w']'
a_2 = PseudoI*b_2;
a_3 = PseudoI*b_3;

syms x1 x2
x = [x1;x2];
g1 = a_1(1) + a_1(2:3)'*x;
g2 = a_2(1) + a_2(2:3)'*x;
g3 = a_3(1) + a_3(2:3)'*x;

figure(2); clf;
scatter(Xc1(:,1),Xc1(:,2),'k','filled');
hold on;
scatter(Xc2(:,1),Xc2(:,2),'r','filled');
fimplicit(g1,[0 4 0 4],'b');
fimplicit(g2,[0 4 0 4],'c');
fimplicit(g3,[0 4 0 4],'g');
grid on;
xlim([0,4]); ylim([0,4]);
legend('Clase 1','Clase 2','b=ones','b=1:4','b=rand');
