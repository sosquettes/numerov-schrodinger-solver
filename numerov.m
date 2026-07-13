% Método de numerov para ecuaciones de la forma  y'' = -k^2(x)y de forma
%explicita
function [t, psi] = numerov(V, E, a, b, h, y0, psi1)
    
    %   V: funcion de potencial
    %   E: energia 
    %   a: intervalo [a,b]
    %   b
    %   h: Tamaño de paso
    %   y0: valor inicial
    %   psi1: valor en el paso 1

    t = a : h : b;
    N = length(t);
    psi = zeros(1, N);
    
    psi(1) = y0;
    if N > 1
        psi(2) = psi1;
    end
    
    % numerov explicito
    for i = 2 : N-1
        % Calcular k^2 en los tres pasos
        k2_prev = E - V(t(i-1));
        k2_curr = E - V(t(i));
        k2_next = E - V(t(i+1));
        
        % constantes auxiliares
        c_prev = (h^2 / 12) * k2_prev;
        c_curr = (h^2 / 12) * k2_curr;
        c_next = (h^2 / 12) * k2_next;

        % numerador / denominador
        term1 = 2 * (1 - 5 * c_curr) * psi(i);
        term2 = (1 + c_prev) * psi(i-1);
        psi(i+1) = (term1 - term2) / (1 + c_next);
    end
end