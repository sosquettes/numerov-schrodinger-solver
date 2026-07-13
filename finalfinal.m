a = 0; %intervalo [a,b]
b = 10;  
y0 = 0; %valor iniciales
dy0 = 1;
h_values = [0.5, 0.1, 0.05];
colores = {'r', 'b', 'm'};

% vectores para los errores
error_max_num = zeros(1, length(h_values));
error_max_rk4 = zeros(1, length(h_values));

% Definimos las condiciones del problema (partícula libre)
V = @(x) 0 .* x; 
E = 1;           
fig_numerov = figure('Name', 'Método de Numerov vs Real');
fig_rk4 = figure('Name', 'Runge-Kutta 4 vs Real');

for i = 1:length(h_values)
    h = h_values(i);
    c = colores{i};
   
    %   numerov
    psi1 = sin(sqrt(E) * h); % segundo paso
    [t_num, psi_num] = numerov(V, E, a, b, h, y0, psi1);
    
    %   runge-kutta 4
    [t_rk, psi_rk4] = rk4(V, E, a, b, h, y0, dy0);
    
    %solución real
    psi_real = sin(sqrt(E) * t_num); 
    
    % errores absolutos
    error_num = max(abs(psi_real - psi_num));
    error_rk4 = max(abs(psi_real - psi_rk4));
    
    % Guardamos los errores en el arreglo para la gráfica final
    error_max_num(i) = error_num;
    error_max_rk4(i) = error_rk4;
    
    disp(['Tamaño de paso h = ' num2str(h)]);
    disp(['  Error Máx Numerov: ' num2str(error_num)]);
    disp(['  Error Máx RK4:     ' num2str(error_rk4)]);
    disp(' ');
    
    %   graficas
    %   numerov
    figure(fig_numerov);
    subplot(length(h_values), 1, i);
    plot(t_num, psi_num, [c '--o'], 'LineWidth', 1.5, 'MarkerSize', 4, 'MarkerFaceColor', c); hold on;
    plot(t_num, psi_real, 'k-', 'LineWidth', 1.5);
    
    title(['Numerov vs Real (h = ' num2str(h) ')']);
    xlabel('Posición x'); 
    ylabel('\psi(x)'); 
    grid on; 
    set(gca, 'FontSize', 11);
    legend(['Numerov h=' num2str(h)], 'Real', 'Location', 'best');
    
    %   rk4
    figure(fig_rk4);
    subplot(length(h_values), 1, i);
    plot(t_rk, psi_rk4, [c '--+'], 'LineWidth', 1.5, 'MarkerSize', 5); hold on;
    plot(t_num, psi_real, 'k-', 'LineWidth', 1.5);
    
    title(['RK4 vs Real (h = ' num2str(h) ')']);
    xlabel('Posición x'); 
    ylabel('\psi(x)'); 
    grid on; 
    set(gca, 'FontSize', 11);
    legend(['RK4 h=' num2str(h)], 'Real', 'Location', 'best');
end

%   grafica del error en loglog
figure('Name', 'Error Absoluto vs h');
loglog(h_values, error_max_num, 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r'); hold on;
loglog(h_values, error_max_rk4, 'b+-', 'LineWidth', 1.5, 'MarkerSize', 8);
grid on;
title('Error Absoluto Global vs Tamaño de paso (h)');
xlabel('Tamaño de paso (h)');
ylabel('Error Absoluto (norma del supremo)');
legend('Numerov', 'RK4', 'Location', 'best');
set(gca, 'FontSize', 11);


p_num = polyfit(log(h_values), log(error_max_num), 1);
p_rk4 = polyfit(log(h_values), log(error_max_rk4), 1);

%   obtenemos la pendiente
orden_exp = p_num(1); 
orden_mod = p_rk4(1);

% Mostrar resultados en la consola
fprintf('Orden de convergencia aproximado para Numerov: %.5f\n', orden_exp);
fprintf('Orden de convergencia aproximado para Runge-Kutta 4: %.5f\n', orden_mod);