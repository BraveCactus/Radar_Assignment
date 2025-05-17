% Сравнение радиоимпульса и ЛЧМ сигнала

function main()
    %% Инициализация и параметры
    clear all;
    close all;
    format compact;
    clc;
    
    % Общие параметры
    sampling_rate = 10e3;       % Частота дискретизации [Гц]
    pulse_duration = 0.1;       % Длительность импульса [сек]
    time_vector = -pulse_duration/2:1/sampling_rate:pulse_duration/2;
    N = length(time_vector);
    freq_vector = (-N/2:N/2-1)*(sampling_rate/N); % Частотная ось [Гц]
    
    %% 1. Генерация радиоимпульса
    carrier_freq = 100;         % Несущая частота [Гц]
    rect_envelope = double(abs(time_vector) <= pulse_duration/2);
    radio_pulse = rect_envelope .* cos(2*pi*carrier_freq*time_vector);
    
    % Расчет спектра
    radio_spectrum = abs(fftshift(fft(radio_pulse))) / N;
    
    %% 2. Генерация ЛЧМ сигнала
    bandwidth = 2000;           % Полоса частот [Гц]
    chirp_rate = bandwidth / pulse_duration;
    center_freq = 1000;         % Центральная частота [Гц]
    
    % Формирование ЛЧМ сигнала
    lfm_pulse = rect_envelope .* cos(2*pi*(center_freq*time_vector + 0.5*chirp_rate*time_vector.^2));
    
    % Расчет спектра
    lfm_spectrum = abs(fftshift(fft(lfm_pulse))) / N;
    
    %% Визуализация результатов
    fig = figure('Name', 'Сравнение сигналов', ...
                'Position', [100 100 1000 800], ...
                'Color', 'w');
    
    % 1. График радиоимпульса
    subplot(2,2,1);
    plot(time_vector*1e3, radio_pulse, 'b', 'LineWidth', 1.8);
    xlabel('Время, мс', 'FontSize', 10);
    ylabel('Амплитуда', 'FontSize', 10);
    title('Радиоимпульс (f_0 = 100 Гц)', 'FontSize', 12);
    grid on;
    xlim([-50 50]);
    set(gca, 'FontName', 'Arial', 'XMinorTick', 'on', 'YMinorTick', 'on');
    
    % 2. Спектр радиоимпульса
    subplot(2,2,2);
    plot(freq_vector, radio_spectrum, 'b', 'LineWidth', 1.8);
    xlabel('Частота, Гц', 'FontSize', 10);
    ylabel('Амплитуда', 'FontSize', 10);
    title('Спектр радиоимпульса', 'FontSize', 12);
    grid on;
    xlim([-300 300]);
    set(gca, 'FontName', 'Arial', 'XMinorTick', 'on', 'YMinorTick', 'on');
    
    % 3. График ЛЧМ сигнала
    subplot(2,2,3);
    plot(time_vector*1e3, lfm_pulse, 'r', 'LineWidth', 1.8);
    xlabel('Время, мс', 'FontSize', 10);
    ylabel('Амплитуда', 'FontSize', 10);
    title(['ЛЧМ сигнал (f_0 = ' num2str(center_freq/1e3) ' кГц, B = ' num2str(bandwidth/1e3) ' кГц)'], 'FontSize', 12);
    grid on;
    xlim([-50 50]);
    set(gca, 'FontName', 'Arial', 'XMinorTick', 'on', 'YMinorTick', 'on');
    
    % 4. Спектр ЛЧМ сигнала
    subplot(2,2,4);
    plot(freq_vector, lfm_spectrum, 'r', 'LineWidth', 1.8);
    xlabel('Частота, Гц', 'FontSize', 10);
    ylabel('Амплитуда', 'FontSize', 10);
    title('Спектр ЛЧМ сигнала', 'FontSize', 12);
    grid on;
    xlim([-3e3 3e3]);
    set(gca, 'FontName', 'Arial', 'XMinorTick', 'on', 'YMinorTick', 'on');
    
    %% Общее оформление
    annotation(fig, 'textbox', [0.25 0.93 0.5 0.05], ...
              'String', 'Сравнение радиоимпульса и ЛЧМ сигнала', ...
              'EdgeColor', 'none', 'FontSize', 14, ...
              'FontWeight', 'bold', 'HorizontalAlignment', 'center');    
end