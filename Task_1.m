%% Задание 1. Построение сигналов

function main()
    %% Инициализация среды
    clear all;
    close all;       
    format compact;
    clc;   
    
    %% Конфигурация параметров
    config = struct(...
        'sampleRate',   25000, ...       % Частота дискретизации (Гц)
        'duration',     1.2, ...         % Длительность записи (сек)
        'carrierFreq',  80, ...          % Несущая частота (Гц)
        'amplitude',    0.8, ...         % Амплитуда сигнала
        'pulseCount',   6, ...           % Число импульсов в последовательности
        'noiseSigma',   0.4, ...         % СКО шума
        'pulseWidth',   0.18, ...        % Ширина импульса (сек)
        'pulseSpacing', 0.22 ...         % Интервал между импульсами (сек)
    );
    
    %% Генерация временной оси
    t = 0:1/config.sampleRate:config.duration;
    t = t(1:end-1);  % Корректировка длины
    
    %% Визуализация сигналов
    hFig = createFigure(config);
    
    %% 1. Одиночный треугольный импульс
    singlePulse = generateTriangularPulse(t, 0.5, config);
    plotSignal(hFig, 1, t, singlePulse, 'b-', 1.8, ...
        'Одиночный треугольный импульс', 'Амплитуда');
    
    %% 2. Модулированный импульс
    modulatedPulse = singlePulse .* cos(2*pi*config.carrierFreq*t);
    plotSignal(hFig, 2, t, modulatedPulse, 'm-', 1.6, ...
        'Радиоимпульс с треугольной огибающей', 'Амплитуда');
    
    %% 3. Последовательность импульсов
    pulseTrain = generatePulseTrain(t, config);
    plotSignal(hFig, 3, t, pulseTrain, 'g-', 1.8, ...
        'Последовательность треугольных импульсов', 'Амплитуда');
    
    %% 4. Последовательность радиоимпульсов
    rfPulseTrain = generateRfPulseTrain(t, config);
    plotSignal(hFig, 4, t, rfPulseTrain, 'r-', 1.4, ...
        'Последовательность радиоимпульсов', 'Амплитуда');
    
    %% 5. Зашумленный сигнал
    noisySignal = addNoise(rfPulseTrain, config);
    plotSignal(hFig, 5, t, noisySignal, 'k-', 1.2, ...
        'Зашумленный радиоимпульс', 'Амплитуда');
    
    %% Добавление заголовка
    annotation(hFig, 'textbox', [0.3 0.94 0.4 0.05], ...
        'String', 'Моделирование импульсных сигналов', ...
        'EdgeColor', 'none', 'FontSize', 14, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

%% Вспомогательные функции
function fig = createFigure(config)
    fig = figure('Name', 'Импульсные сигналы', ...
        'Position', [150 80 1000 950], ...
        'Color', [0.98 0.98 0.98], ...
        'NumberTitle', 'off');
    
    for i = 1:5
        subplot(5,1,i);
        set(gca, 'FontName', 'Arial', ...
            'GridAlpha', 0.25, ...
            'XMinorGrid', 'on', ...
            'YMinorGrid', 'on');
        hold on;
        box on;
    end
end

function pulse = generateTriangularPulse(t, center, config)
    pulse = config.amplitude * ...
        tripuls(t - center, config.pulseWidth);
end

function train = generatePulseTrain(t, config)
    train = zeros(size(t));
    for k = 0:config.pulseCount-1
        pos = k*config.pulseSpacing + 0.15;
        train = train + generateTriangularPulse(t, pos, config);
    end
end

function rfTrain = generateRfPulseTrain(t, config)
    baseTrain = generatePulseTrain(t, config);
    carrier = cos(2*pi*config.carrierFreq*t);
    rfTrain = baseTrain .* carrier;
end

function noisy = addNoise(signal, config)
    noise = config.noiseSigma * randn(size(signal));
    noisy = signal + noise;
end

function plotSignal(fig, pos, t, y, style, width, titleStr, ylabelStr)
    figure(fig);
    subplot(5,1,pos);
    plot(t, y, style, 'LineWidth', width);
    
    title(titleStr, 'FontSize', 11);
    ylabel(ylabelStr, 'FontSize', 10);
    xlabel('Время (сек)', 'FontSize', 10);
    grid on;
    
    % Автоматическое определение пределов
    yMax = max(abs(y))*1.3;
    if yMax == 0, yMax = 1; end
    ylim([-yMax yMax]);
end