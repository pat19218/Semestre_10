tamanio_crl = 25;

general = ...
    [Features_result.CarIctal.VectorCaracteristicasIctal(:,4), ...
    Features_result.CarIctal.VectorCaracteristicasIctal(:,5);...
    Features_result.CarSano.VectorCaracteristicasSano(:,4),...
    Features_result.CarSano.VectorCaracteristicasSano(:,5)];

ClusteringJerarquico = ...
    clusterdata(general,'Linkage','ward','SaveMemory','on','Maxclust',2); 

size_ictal = size(Features_result.CarIctal.VectorCaracteristicasIctal);
size_sano= size(Features_result.CarSano.VectorCaracteristicasSano);

clases = [ones(size_ictal(1),1);2*(ones(size_sano(1),1))];


scatter(general(:,1),general(:,2),tamanio_crl, ClusteringJerarquico,'filled');