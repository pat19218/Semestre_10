%--------------------------------------------------------------------------
%  Nombre:      Cristhofer Patzán
%  Carné:       19219
%  Descripcion: Toma los datos almacenados en el documento standar de UVG
%               para BIOPAC MP41, debido a que este presenta un ruido,
%               luego los convierte en un struct, para poder usar
%               dichos datos en la ToolBox.
%--------------------------------------------------------------------------
function gen_struc_filter(filename, save_name)
   
    signal = readmatrix(filename);

    eeg_struct.data = signal(:,2)';
    eeg_struct.data_length_sec = size(eeg_struct.data,2);
    eeg_struct.sampling_frequency = signal(1,8);
    eeg_struct.channels = {'Canal 1'};

    %Wc_low = 45/Fs_eeg;             %FrecuenciaCorte / FrecuenciaMuestreo
    Wc_high = 10/Fs_eeg;

    % [nume , deno] = butter(orden, corte, tipoFiltro)
    %[b_low, a_low] = butter(2,Wc_low,'low');
    [b_high, a_high] = butter(2,Wc_high,'high');

    %SenialFiltrada = filter(nume, deno, senial)     pasaaltas
    eeg_struct.data = filter(b_high, a_high, eeg_struct.data);

    save(save_name,'eeg_struct')
    
end