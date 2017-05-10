%% Signature surface generation script
syms x y
f = exp(-2*x.^2 - 4.*sin(y + x).^2);
f_numeric = matlabFunction(f);
draw_image(f)
[X, Y] = regular_grid(-1, 1, 500, -1, 1, 500);
%% E(2)
sig = E2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% SE(2)
sig = SE2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% SA(2)
sig = SA2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% A(2)
sig = A2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% PSL(3, R)
sig = PSL3R_signature(f);
draw_signature(sig.evaluate(X, Y))
