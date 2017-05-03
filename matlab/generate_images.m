%% Signature visualisation script
xlim = [-0.5 0.5];
ylim = [-0.5, 0.5];
n = 1000;
x = linspace(xlim(1), xlim(2), n);
y = linspace(ylim(1), ylim(2), n);
hx = (xlim(2) - xlim(1)) / (n - 1);
hy = (ylim(2) - ylim(1)) / (n - 1);
[X, Y] = meshgrid(x, y);

f = @(x, y) 0.05*x.^3 - 0.2*x.^2.*y + 0.1*x*y.^2 - 0.1*y.^3 + ...
   0.3*x.^2 - 0.2*x.*y.^2 + 0.4*y.^2 + 0.1*x + 0.1*y + 1;
%f = @(x, y) exp(-x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
syms x y
F = f(x, y);
F_num = f(X, Y);
figure(1)
surf(X, Y, F_num, 'edgecolor', 'none')
print -r200 -dpng figures/f.png

%%
sym_to_numeric = @(sig) cellfun(@matlabFunction, sig, 'UniformOutput', false)
eval_sig = @(sig, X, Y) cellfun(@(f) f(X, Y), sig, 'UniformOutput', false);
eval_sym = @(sig, X, Y) eval_sig(sym_to_numeric(sig), X, Y);

sig_R2   = eval_sym(R2_signature(F), X, Y);
sig_SE2  = eval_sym(SE2_signature(F, hx, hy),X,Y);
sig_E2   = eval_sym(E2_signature(F, hx, hy),X,Y);
sig_Sim2 = eval_sym(Sim2_signature(F, hx, hy),X,Y);
sig_SA2  = eval_sym(SA2_signature(F, hx, hy),X,Y);
sig_A2   = eval_sym(A2_signature(F, hx, hy),X,Y);

%%
figure(2)
subplot(2, 3, 1)
sig_surface(sig_R2)
title('R^2 signature')
subplot(2, 3, 2)
sig_surface(sig_SE2)
title('SE(2) signature')
subplot(2, 3, 3)
sig_surface(sig_E2)
title('E(2) signature')
subplot(2, 3, 4)
sig_surface(sig_Sim2)
title('Sim(2) signature')
subplot(2, 3, 5)
sig_surface(sig_SA2)
title('SA(2) signature')
subplot(2, 3, 6)
sig_surface(sig_A2)
title('A(2) signature')
print -r200 -dpng figures/some_sigs.png
%%
levels = linspace(min(F_num(:)), max(F_num(:)), 10);
figure(3)
subplot(2, 3, 1)
sig_contour(sig_R2, 'levels', levels)
title('R^2 signature')
subplot(2, 3, 2)
sig_contour(sig_SE2, 'levels', levels)
title('SE(2) signature')
subplot(2, 3, 3)
sig_contour(sig_E2, 'levels', levels)
title('E(2) signature')
subplot(2, 3, 4)
sig_contour(sig_Sim2)
title('Sim(2) signature')
subplot(2, 3, 5)
sig_contour(sig_SA2, 'levels', levels)
title('SA(2) signature')
subplot(2, 3, 6)
sig_contour(sig_A2)
title('A(2) signature')
print -r200 -dpng figures/some_contours.png


%% sig = SE2_signature(F, hx, hy);
