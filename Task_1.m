% Task_1 - Генерация импульсов (треугольных и радиоимпульсов)
clear all;
close all;
clc;

%% Параметры сигналов
Fs = 20000;          % Увеличена частота дискретизации для более гладких графиков
T = 1;               % Длительность сигнала (с)
t = 0:1/Fs:T-1/Fs;   % Временная ось
f0 = 100;            % Увеличена частота радиоимпульса для лучшей визуализации
A = 1;               % Амплитуда импульсов
N_pulse = 5;         % Количество импульсов в пачке
noise_level = 0.5;   % Уровень шума увеличен для наглядности

%% Создание фигуры 
figure('Position', [100, 100, 1200, 900], 'Color', 'w');
set(gcf, 'DefaultAxesFontSize', 10, 'DefaultAxesFontWeight', 'bold');

%% 1. Одиночный треугольный видеоимпульс
pulse_width = 0.15;  % Уменьшена длительность импульса
tri_pulse = A * tripuls(t - 0.3, pulse_width);

subplot(5, 1, 1);
plot(t, tri_pulse, 'LineWidth', 2, 'Color', [0, 0.5, 0.8]);
title('Одиночный треугольный видеоимпульс', 'FontSize', 12);
xlabel('Время (с)', 'FontSize', 10);
ylabel('Амплитуда', 'FontSize', 10);
grid on;
ylim([0, A*1.2]);
set(gca, 'GridAlpha', 0.3);

%% 2. Одиночный радиоимпульс (с треугольной огибающей)
radio_pulse = tri_pulse .* sin(2*pi*f0*t);

subplot(5, 1, 2);
plot(t, radio_pulse, 'LineWidth', 1.5, 'Color', [0.8, 0.2, 0.2]);
title('Одиночный радиоимпульс с треугольной огибающей', 'FontSize', 12);
xlabel('Время (с)', 'FontSize', 10);
ylabel('Амплитуда', 'FontSize', 10);
grid on;
ylim([-A*1.2, A*1.2]);
set(gca, 'GridAlpha', 0.3);

%% 3. Пачка треугольных видеоимпульсов
pulse_period = 0.25;  % Уменьшен период следования импульсов
tri_pulse_train = zeros(size(t));

for k = 0:N_pulse-1
    pulse_start = k * pulse_period;
    tri_pulse_train = tri_pulse_train + A * tripuls(t - pulse_start - pulse_width/2, pulse_width);
end

subplot(5, 1, 3);
plot(t, tri_pulse_train, 'LineWidth', 2, 'Color', [0, 0.6, 0.3]);
title('Пачка треугольных видеоимпульсов', 'FontSize', 12);
xlabel('Время (с)', 'FontSize', 10);
ylabel('Амплитуда', 'FontSize', 10);
grid on;
ylim([0, A*1.2]);
set(gca, 'GridAlpha', 0.3);

%% 4. Пачка радиоимпульсов (с треугольной огибающей)
radio_pulse_train = zeros(size(t));

for k = 0:N_pulse-1
    pulse_start = k * pulse_period;
    radio_pulse_segment = A * tripuls(t - pulse_start - pulse_width/2, pulse_width) .* ...
                         sin(2*pi*f0*(t - pulse_start));
    radio_pulse_train = radio_pulse_train + radio_pulse_segment;
end

subplot(5, 1, 4);
plot(t, radio_pulse_train, 'LineWidth', 1.5, 'Color', [0.7, 0, 0.7]);
title('Пачка радиоимпульсов с треугольной огибающей', 'FontSize', 12);
xlabel('Время (с)', 'FontSize', 10);
ylabel('Амплитуда', 'FontSize', 10);
grid on;
ylim([-A*1.2, A*1.2]);
set(gca, 'GridAlpha', 0.3);

%% 5. Добавление шума к пачке радиоимпульсов
noisy_radio_pulse_train = radio_pulse_train + noise_level * A * randn(size(t));

subplot(5, 1, 5);
plot(t, noisy_radio_pulse_train, 'LineWidth', 1, 'Color', [0.3, 0.3, 0.3]);
title(['Пачка радиоимпульсов с добавленным шумом (SNR = ' ...
      num2str(20*log10(A/noise_level), '%.1f') ' dB)'], 'FontSize', 12);
xlabel('Время (с)', 'FontSize', 10);
ylabel('Амплитуда', 'FontSize', 10);
grid on;
ylim([-A*1.8, A*1.8]);
set(gca, 'GridAlpha', 0.3);

%% Общее оформление
sgtitle('Генерация импульсов с различными параметрами', 'FontSize', 14, 'FontWeight', 'bold');

% Добавление подписи внизу
annotation('textbox', [0.4 0.01 0.2 0.03], 'String', ...
          'MATLAB Signal Generation Demo', 'EdgeColor', 'none', ...
          'HorizontalAlignment', 'center', 'FontSize', 10, 'FontAngle', 'italic');