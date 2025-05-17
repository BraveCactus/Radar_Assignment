%Задание 2. ЛЧМ, АКФ ЛЧМ 

function main()
    %% Инициализация и параметры
    clear workspace;  % Очистка рабочей области
    close all;        % Закрытие всех графиков
    format compact;   % Компактный вывод
    clc;
    
    % Основные параметры сигнала
    sampling_rate = 10e3;       % Частота дискретизации [Гц]
    pulse_duration = 100e-3;    % Длительность импульса [сек]
    freq_start = 100;           % Начальная частота [Гц]
    freq_end = 500;             % Конечная частота [Гц]
    signal_amplitude = 1.0;     % Амплитуда сигнала
    
    %% Генерация временной оси
    time_vector = (0:1/sampling_rate:pulse_duration-1/sampling_rate)';
    
    %% 1. Формирование ЛЧМ сигнала
    bandwidth = freq_end - freq_start;
    chirp_rate = bandwidth / pulse_duration;
    
    % Расчет фазовой функции
    phase = 2*pi*(freq_start*time_vector + 0.5*chirp_rate*time_vector.^2);
    
    % Генерация сигнала
    lfm_signal = signal_amplitude * cos(phase);
    
    %% Визуализация сигнала
    fig = figure('Name', 'Анализ ЛЧМ сигнала', ...
                'Position', [100 100 800 600], ...
                'Color', 'w');
    
    % График сигнала
    subplot(2, 1, 1);
    plot(time_vector*1e3, lfm_signal, 'b', 'LineWidth', 1.8);
    xlabel('Время, мс', 'FontSize', 10);
    ylabel('Амплитуда', 'FontSize', 10);
    title('Форма ЛЧМ сигнала', 'FontSize', 12);
    grid on;
    axis tight;
    set(gca, 'FontName', 'Arial', 'XMinorTick', 'on', 'YMinorTick', 'on');
    
    %% 2. Расчет автокорреляционной функции
    [correlation, delay_samples] = xcorr(lfm_signal, 'normalized');
    delay_time = delay_samples / sampling_rate;
    
    % График АКФ
    subplot(2, 1, 2);
    plot(delay_time*1e3, correlation, 'r', 'LineWidth', 1.8);
    xlabel('Задержка, мс', 'FontSize', 10);
    ylabel('Нормированная АКФ', 'FontSize', 10);
    title('Автокорреляционная функция', 'FontSize', 12);
    grid on;
    xlim([-20 20]);
    set(gca, 'FontName', 'Arial', 'XMinorTick', 'on', 'YMinorTick', 'on');
    
    %% Общее оформление
    annotation(fig, 'textbox', [0.3 0.93 0.4 0.05], ...
              'String', 'Анализ характеристик ЛЧМ сигнала', ...
              'EdgeColor', 'none', 'FontSize', 14, ...
              'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
    % Сохранение данных
    save('lfm_signal_data.mat', 'lfm_signal', 'time_vector');
end
