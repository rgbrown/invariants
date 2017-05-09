%% E(2) Reconstruction

%% Greyscale
% signature (f, f_i f_i, f_ii)


%% Colour
% signature (f1 + f2, f1_i^2 + f2_i^2, f1_i f2_i)

%% Three colour image
syms x y
f_sym(x, y) = exp(-4*x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
g_sym(x, y) = exp(-5*(x.^2 + y.^2)).*sin(2*pi*(x+y));
h_sym(x, y) = 0.1*sign(x).^2;
f = matlabFunction(f_sym);
g = matlabFunction(g_sym);
h = matlabFunction(h_sym);

npts = 500;
x = linspace(-1, 1, npts);
dx = 2 / (npts - 1);
y = x;
[X, Y] = meshgrid(x, y);

I = cat(3, f(X, Y), g(X, Y), h(X, Y));
figure(1)
imshow(I)
%% Construct the ****ing images
F = f(X, Y);
G = g(X, Y);
H = h(X, Y);

tform = E2Transform(1.1, -1, -0.1, 0.2);
[Xp, Yp] = tform.reverse(X, Y);

Fp = f(Xp, Yp);
Gp = g(Xp, Yp);
Hp = h(Xp, Yp);
%%
sig = E2_colour_signature(F, G, dx);
sig1 = E2_colour_signature(Fp, Gp, dx);
levels = linspace(0, 1, 3);
contour(sig{2}, sig{3}, sig{1}, levels, 'linewidth', 2, 'linecolor', 'blue')
hold on
contour(sig1{2}, sig1{3}, sig1{1}, levels, 'linewidth', 2, 'linecolor', 'red')

%%
surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
hold on
surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);
