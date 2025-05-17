% Задание 4. Анализ дискретных сигналов и их преобразований

function main()
    %% Инициализация и параметры
    clear all;
    close all;       
    format compact;   
    clc;
    
    % Параметры сигналов
    num_samples = 30;            % Количество отсчетов
    sample_rate = 1e3;           % Частота дискретизации [Гц]
    signal_freq = 50;            % Частота гармонического сигнала [Гц]
    interp_factor = 4;           % Коэффициент интерполяции
    decim_factor = 2;            % Коэффициент децимации
    
    %% Генерация временной оси
    n = (0:num_samples-1)';      
    
    %% 1. Создание тестовых сигналов
    % Базовые сигналы
    impulse_signal = [1; zeros(num_samples-1, 1)];
    constant_signal = ones(num_samples, 1);
    linear_signal = (0:num_samples-1)';
    
    % Гармонический сигнал
    harmonic_signal = cos(2*pi*signal_freq*n/sample_rate);
    
    %% 2. Преобразования сигналов
    % Интерполяция
    interp_signal = interp(harmonic_signal, interp_factor);
    n_interp = (0:1/interp_factor:num_samples-1/interp_factor)';
    
    % Децимация
    decim_signal = decimate(harmonic_signal, decim_factor);
    n_decim = (0:decim_factor:num_samples-1)';
    
    %% Визуализация результатов
    fig = figure('Name', 'Дискретные сигналы и преобразования', ...
                'Position', [100 100 1000 900], ...
                'Color', 'w');
    
    % Цветовая схема
    colors = lines(7);
    
    %% Графики базовых сигналов
    % Единичный импульс
    subplot(4, 2, 1);
    stem(n, impulse_signal, 'filled', 'Color', colors(1,:), 'LineWidth', 1.6);
    title('Единичный импульс', 'FontSize', 11);
    ylabel('Амплитуда', 'FontSize', 10);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    % Постоянный сигнал
    subplot(4, 2, 3);
    stem(n, constant_signal, 'filled', 'Color', colors(2,:), 'LineWidth', 1.6);
    title('Постоянный сигнал', 'FontSize', 11);
    ylabel('Амплитуда', 'FontSize', 10);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    % Линейный сигнал
    subplot(4, 2, 5);
    stem(n, linear_signal, 'filled', 'Color', colors(3,:), 'LineWidth', 1.6);
    title('Линейный сигнал', 'FontSize', 11);
    ylabel('Амплитуда', 'FontSize', 10);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    % Гармонический сигнал
    subplot(4, 2, 7);
    stem(n, harmonic_signal, 'filled', 'Color', colors(4,:), 'LineWidth', 1.6);
    title(['Гармонический сигнал (' num2str(signal_freq) ' Гц)'], 'FontSize', 11);
    xlabel('Отсчеты', 'FontSize', 10);
    ylabel('Амплитуда', 'FontSize', 10);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    %% Графики преобразований
    % Исходный сигнал (для сравнения)
    subplot(4, 2, 2);
    stem(n, harmonic_signal, 'filled', 'Color', colors(5,:), 'LineWidth', 1.2);
    title('Исходный сигнал', 'FontSize', 11);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    % Интерполяция
    subplot(4, 2, 4);
    stem(n_interp, interp_signal, 'filled', 'Color', colors(6,:), 'LineWidth', 1.2);
    title(['Интерполяция (L=' num2str(interp_factor) ')'], 'FontSize', 11);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    % Исходный сигнал (для сравнения)
    subplot(4, 2, 6);
    stem(n, harmonic_signal, 'filled', 'Color', colors(5,:), 'LineWidth', 1.2);
    title('Исходный сигнал', 'FontSize', 11);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    % Децимация
    subplot(4, 2, 8);
    stem(n_decim, decim_signal, 'filled', 'Color', colors(7,:), 'LineWidth', 1.2);
    title(['Децимация (M=' num2str(decim_factor) ')'], 'FontSize', 11);
    xlabel('Отсчеты', 'FontSize', 10);
    grid on;
    set(gca, 'FontName', 'Arial');
    
    %% Общее оформление
    annotation(fig, 'textbox', [0.3 0.94 0.4 0.05], ...
              'String', 'Анализ дискретных сигналов и их преобразований', ...
              'EdgeColor', 'none', 'FontSize', 14, ...
              'FontWeight', 'bold', 'HorizontalAlignment', 'center');  
   
end