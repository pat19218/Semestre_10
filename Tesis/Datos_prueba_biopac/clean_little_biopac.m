function clean_little_biopac(filename)
    data_emg = readtable(filename,'Range','A:B'); %30286
    data_emg = table2array(data_emg);
    Fs_eeg = 1000;

    % figure(1)
    % plot(data_emg(:,1),data_emg(:,2));


    Wc_low = 45/Fs_eeg;             %FrecuenciaCorte / FrecuenciaMuestreo
    Wc_high = 10/Fs_eeg;

    % [nume , deno] = butter(orden, corte, tipoFiltro)
    [b_low, a_low] = butter(2,Wc_low,'low');
    [b_high, a_high] = butter(2,Wc_high,'high');

    %SenialFiltrada = filter(nume, deno, senial)     pasaaltas
    EMG_filt = filter(b_high, a_high, data_emg(:,2));

    figure()
    plot(data_emg(:,1),data_emg(:,2));
    hold on
    plot(data_emg(:,1),EMG_filt);
    hold off
    title('Señales EMG BIOPAC')
    legend([{'Biopac data'},{'filtrada'}])
end