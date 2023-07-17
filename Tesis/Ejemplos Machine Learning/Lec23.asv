%% IE3042 - Temas Especiales de Electrónica y Mecatrónica 2
%  Lección 23 - Ejemplo
%  Luis Alberto Rivera

%% Generación de muestras
% mu1 = [-5 5]'; mu2 = [0 -3]'; mu3 = [8 8]'; mu4 = [1 4]'; mu5 = [2 12]';
% Sig1 = 2*[1.5 0;0 1]; Sig2 = 2*[1 0;0 1]; Sig3 = 2*[1 0.5;0.5 1];
% Sig4 = 2*[1 0;0 1]; Sig5 = 2*[3 0;0 1];
% N1 = 100; N2 = 150; N3 = 200; N4 = 120; N5 = 80;
% 
% X1 = mvnrnd(mu1,Sig1,N1); X2 = mvnrnd(mu2,Sig2,N2); X3 = mvnrnd(mu3,Sig3,N3);
% X4 = mvnrnd(mu4,Sig4,N4); X5 = mvnrnd(mu5,Sig5,N5);
% X = [X1;X2;X3;X4;X5];
% X = X(randperm(size(X,1)),:);
% 
% outliers = [mvnrnd([15,-10],4*eye(2),5);mvnrnd([0,25],4*eye(2),5)];
% X_out = [X;outliers];
% X_out = X_out(randperm(size(X_out,1)),:);
% 
% save L23_datos.mat X X_out
% 
% figure(1); clf;
% scatter(X_o(:,1),X_o(:,2));

%% Ictal Sano Kmeans
% Etiquetas
% EtiquetasIctalSanoCol = [zeros(409700,1);ones(409700,1)] ;
% load EtiquetasIctalSanoSVM.mat;
% 
% % Ubonn SANO
% load('SetA_Sano_UBonn.mat', 'eeg_struct'); % 409,700
% datos_Sano = eeg_struct.data;
% datos_SanoCol = datos_Sano.';
% 
% % Ubonn ICTAL
% load('SetE_Ictal_UBonn.mat', 'eeg_struct') % 409,700
% datos_Ictal = eeg_struct.data;
% datos_IctalCol = datos_Ictal.';
% 
% % DATOS
% datosIctalSanoCol = [datos_IctalCol;datos_SanoCol];
% 
% 
% m = 2;
% % [E1, centros_km] = k_means(X, m, 1);
% [E2, centros2] = k_means(datosIctalSanoCol, m, 2);
% 
% rands = Rand_index(E2,EtiquetasIctalSanoCol);

% figure(1); clf;
% scatter(datosIctalSanoCol(:,1),datosIctalSanoCol(:,2),'filled');

%% Ictal Sano Jerarquico
 
load('EtiquetasIctalSanoSVM.mat')
load('VecCarIctalSano12.mat')
load('VecCarIctalSano123456.mat')

%Hierarchical_Clustering = clusterdata(VecCarIctalSano,5);

rng('default');  % For reproducibility
X = rand(20000,3);
H_IS_6features = clusterdata(VecCarIctalSano123456,'Linkage','ward','SaveMemory','on','Maxclust',2); %123456
H_IS_2features = clusterdata(VecCarIctalSano,'Linkage','ward','SaveMemory','on','Maxclust',2); %12 

Prueba = clusterdata(VecCarIctalSano,2); %12
randprueba =  Rand_index(Prueba,EtiquetasIctalSanoSVM);

rands_IS_6features = Rand_index(H_IS_6features,EtiquetasIctalSano);
rands_IS_2features = Rand_index(H_IS_2features,EtiquetasIctalSanoSVM);

load('VectorFeatures_2clases_frecuencia_6features.mat', 'Features_result')
PruebaJerarquico = clusterdata(Features_result,'Linkage','ward','SaveMemory','on','Maxclust',2);

%% Interictal Preictal Jerarquico

load('VecCarInterictalPerictal123456.mat', 'VecCarInterictalPerictal')
load('EtiquetasInterictalPerictalSVM.mat')

H_IntP_6features = clusterdata(VecCarInterictalPerictal,'Linkage','ward','SaveMemory','on','Maxclust',2); %123456
rands_IntP_6features = Rand_index(H_IntP_6features,EtiquetasInterictalPreictalSVM);


