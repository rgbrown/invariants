function S = omega_process(f)
% Note: f is a function of four variables, x_a, y_a, x_b, y_b
syms x_a y_a x_b y_b
F(x_a, y_a, x_b, y_b) = f(x_a, y_a, x_b, y_b);
S(x_a, y_a, x_b, y_b) = diff(F, x_a, y_b) - diff(F, x_b, y_a);
end

% % Example usage
% syms Q(x, y)
% H(x_a, y_a, x_b, y_b) = Q(x_a, y_a)*Q(x_b, y_b)
% pretty(omega_process(H))

