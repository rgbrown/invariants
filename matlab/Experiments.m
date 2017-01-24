f = @(x, y) exp(-4*x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
tx = SE2Transform(pi/4, 0.1, -0.2);
visualise_signatures(f, @SE2_signature, tx);



%tx = Sim2Transform(pi/4, 0.1, -0.2, 0.8);

%% PSL3R experiment
tx = PSL3RTransform(1, 0.1, 0.05, 0.8, 0.2, 0.3);
f = @(x, y) exp(-4*x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
visualise_signatures(f, @PSL3R_signature, tx)

%%
figure(1) 
npts = 10000;
xmin = -1;
xmax = 1;
x = linspace(xmin, xmax, npts);
y = linspace(xmin, xmax, npts);
dx = (xmax - xmin) / (npts - 1);
[X, Y] = meshgrid(x, y);
[Xp, Yp] = tx.reverse(X, Y);
F = f(X, Y);
G = f(Xp, Yp);

figure(1)
subplot(1, 2, 1)
imagesc(F)
axis image
subplot(1, 2, 2)
imagesc(G)
axis image

[I0, I1, I2] = PSL3R_signature(F, dx);
[J0, J1, J2] = PSL3R_signature(G, dx);

levels = linspace(0.2, 0.8, 5);
figure(2)

contour(I0, I1, I2, levels, 'k')
hold on
contour(J0, J1, J2, levels, 'r')
hold off


%% Three colour image
syms x y
fs(x, y) = exp(-4*x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
gs(x, y) = exp(-5*(x.^2 + y.^2)).*sin(2*pi*(x+y));
hs(x, y) = 0.5 + 0.25*x - 0.25*y;
f = matlabFunction(fs);
g = matlabFunction(gs);
h = matlabFunction(hs);
%%

npts = 500;
x = linspace(-1, 1, npts);
dx = 2 / (npts - 1);
y = x;
[X, Y] = meshgrid(x, y);

I = cat(3, f(X, Y), g(X, Y), h(X, Y));
figure(1)
imshow(I)

F = f(X, Y);
G = g(X, Y);
H = h(X, Y);

tform = SE2Transform(1.1, -0.1, 0.2);
[Xp, Yp] = tform.reverse(X, Y);

Fp = f(Xp, Yp);
Gp = g(Xp, Yp);
Hp = h(Xp, Yp);

sig = SE2_2col_signature(G, H, dx);
sig1 = SE2_2col_signature(Gp, Hp, dx);


surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
hold on
surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);


%% 1D SE2
[I0, I1, I2] = SE2_signature(F, dx);
[Ip0, Ip1, Ip2] = SE2_signature(Fp, dx);

figure(4)
surf(I0, I1, I2, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
hold on
surf(Ip0, Ip1, Ip2, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);