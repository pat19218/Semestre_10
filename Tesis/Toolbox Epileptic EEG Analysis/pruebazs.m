clear;clc;
unos=[1;1;1];
dos=[2.40;2.70;2.80];
tres=[3;3;3];

tabla = table(unos,dos,tres);

writetable(tabla,'prueba.xls','Sheet','Datos_ToolBox','Range','A1' ...
    )