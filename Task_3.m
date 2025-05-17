% Задание 3. Построение зависимости сигнал/шум (SNR)

function main()
    %% Инициализация и параметры
    clear all;
    close all;       
    format compact;   
    clc;
    
    % Параметры модели
    max_distance = 100;          % Максимальная дальность [м]
    num_objects = 3;             % Количество типов объектов
    num_backgrounds = 2;         % Количество типов фона
    
    % Параметры объектов (эффективная площадь рассеяния)
    object_reflectivity = [10, 5, 1];  % [м^2]
    
    % Параметры фона (уровень шумов)
    background_noise_level = [0.5, 3]; % [Вт]
    
    %% Генерация дальностной оси
    distance_vector = (1:max_distance)';
    
    %% 1. Расчет зависимости SNR от дальности
    snr_matrix = zeros(max_distance, num_objects, num_backgrounds);
    
    for dist = 1:max_distance
        for obj = 1:num_objects
            for bg = 1:num_backgrounds
                % Модель затухания сигнала (закон обратных квадратов)
                signal_power = object_reflectivity(obj) / dist^2;
                
                % Модель шумов (постоянная составляющая + флуктуации)
                noise_power = background_noise_level(bg) * (1 + 0.1*randn());
                
                % Гарантируем положительные значения
                signal_power = max(1e-10, signal_power);
                noise_power = max(1e-10, noise_power);
                
                % Расчет SNR в децибелах
                snr_matrix(dist, obj, bg) = 10*log10(signal_power/noise_power);
            end
        end
    end
    
    %% Визуализация результатов
    fig = figure('Name', 'Зависимость SNR от дальности', ...
                'Position', [100 100 900 700], ...
                'Color', 'w');
    
    % Цвета и стили линий
    line_colors = [0.9 0.2 0.2;    % Красный
                  0.2 0.7 0.2;      % Зеленый
                  0.1 0.3 0.9];     % Синий
    line_styles = {'-', '--'};
    
    % Построение графиков
    hold on;
    for obj = 1:num_objects
        for bg = 1:num_backgrounds
            plot(distance_vector, snr_matrix(:, obj, bg), ...
                'Color', line_colors(obj, :), ...
                'LineStyle', line_styles{bg}, ...
                'LineWidth', 2.2, ...
                'DisplayName', sprintf('Объект %d, Фон %d', obj, bg));
        end
    end
    hold off;
    
    % Оформление графика
    xlabel('Дальность, м', 'FontSize', 11);
    ylabel('Отношение сигнал-шум (SNR), дБ', 'FontSize', 11);
    title('Зависимость SNR от дальности для различных целей', 'FontSize', 12);
    legend('show', 'Location', 'northeast', 'FontSize', 10);
    grid on;
    axis tight;
    set(gca, 'FontName', 'Arial', 'XMinorTick', 'on', 'YMinorTick', 'on');
    
    %% Общее оформление
    annotation(fig, 'textbox', [0.3 0.93 0.4 0.05], ...
              'String', 'Моделирование радиолокационных характеристик', ...
              'EdgeColor', 'none', 'FontSize', 14, ...
              'FontWeight', 'bold', 'HorizontalAlignment', 'center'); 
end