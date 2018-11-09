function T = transvectant(Q, R, r)
%TRANSVECTANT(Q, R, r)
%   Make r-th order transvectant (Q, R)^{(r)}
%
%   Q and R are symbolic functions of two variables
syms x_a y_a x_b y_b x y
% Q, R come in as expressions, nothing we can do about this. This line
% forces them back to being functions
S(x_a, y_a, x_b, y_b) = Q(x_a, y_a)*R(x_b, y_b);
for i = 1:r
    S(x_a, y_a, x_b, y_b) = omega_process(S);
end
T(x, y) = S(x, y, x, y);
end