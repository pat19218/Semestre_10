N1 = size(Features_result.CarIctal.VectorCaracteristicasIctal,1);
N2 = size(Features_result.CarSano.VectorCaracteristicasSano,1);
ind_aleatorio1 = randperm(N1);
ind_aleatorio2 = randperm(N2);
M = 100;

general = [Features_result.CarIctal.VectorCaracteristicasIctal(ind_aleatorio1(1:M),:);...
           Features_result.CarSano.VectorCaracteristicasSano(ind_aleatorio2(1:M),:)];

[D, P]=VAT_2(general, M);