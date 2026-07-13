function [t, y] = rk4(V, E, a, b, h, y0, dy0)

% Entradas:
    %   V: funcion de potencial
    %   E: energia 
    %   a: intervalo [a,b]
    %   b
    %   h: Tamaño de paso
    %   y0: valor inicial
    %   dy0: valor inicial en la derivada

    t = a : h : b;
    N = length(t);
    y = zeros(1, N);
    v = zeros(1, N); % v representa y' 
    
    % Condiciones iniciales
    y(1) = y0;
    v(1) = dy0;
    
    % Runge-Kutta 4
    for i = 1 : N-1
        ti = t(i);
        yi = y(i);
        vi = v(i);
        
        % Definimos f(x, y) = -(E - V(x))y
        f = @(x_val, y_val) -(E - V(x_val)) * y_val;
        
        % Coeficientes de rk4
        k1_y = vi;
        k1_v = f(ti, yi);
        
        k2_y = vi + 0.5 * h * k1_v;
        k2_v = f(ti + 0.5*h, yi + 0.5 * h * k1_y);
        
        k3_y = vi + 0.5 * h * k2_v;
        k3_v = f(ti + 0.5*h, yi + 0.5 * h * k2_y);
        
        k4_y = vi + h * k3_v;
        k4_v = f(ti + h, yi + h * k3_y);
        
        %siguiente paso
        y(i+1) = yi + (h/6) * (k1_y + 2*k2_y + 2*k3_y + k4_y);
        v(i+1) = vi + (h/6) * (k1_v + 2*k2_v + 2*k3_v + k4_v);
    end
end