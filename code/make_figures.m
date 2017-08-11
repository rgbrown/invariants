%% Signature surface generation script
syms x y
%f(x, y) = exp(-2*x.^2 - 4.*sin((y + 0.5*x.^2)).^2);
f(x, y) = 0.6*(exp(-2*x.^2 - 0.5*x.*y - 4*y.^2) + 0.5 + 0.5*sin(2*(x + y)));
f_numeric = matlabFunction(f);

% Mesh for plotting surfaces
xlim = [-0.5, 0.5];
ylim = [-0.5, 0.5];
ngrid = 500;
ny = 480;
[X, Y, xvec, yvec] = regular_grid(xlim(1), xlim(2), ngrid, ...
    ylim(1), ylim(2), ny);

% Scan lines
nline = 1000;
nscan = 11;
Xscan = repmat(linspace(xlim(1), xlim(2), nline), nscan, 1)';
Yscan = repmat(linspace(ylim(1), ylim(2), nscan)', 1, nline)';

%% Write image 
n_image = 2000;
[Xim, Yim, ximvec, yimvec] = regular_grid(xlim(1), xlim(2), n_image, ...
    ylim(1), ylim(2), n_image);
F = f_numeric(Xim, Yim);
draw_image(F, 'xlim', xlim, 'ylim', ylim);
%imwrite(F, 'images/image.jpg')

%% Write transformed image
[Xpi, Ypi] = tform.reverse(Xim, Yim);
imwrite(f_numeric(Xpi, Ypi), strcat('images/', class(tform), '_image.jpg'));

%% Write signature picture
% Manually position the signature and lighting first, then run this:
axis off
print('-r200', '-dpng', strcat('images/', class(tform), '_signature.png'))

%% E(2)
tform = E2Transform(1, -1, 0.1, -0.2);

[Xp, Yp] = tform.reverse(X, Y); % arrays
[xp, yp] = tform.reverse(x, y); %symbolic

sig = E2_signature(f);
sigp = E2_signature(f(xp, yp));

figure(1)
clf
subplot(1,2,1)
draw_image(f_numeric(X, Y), 'xlim', xlim, 'ylim', ylim)
subplot(1,2,2)
draw_image(f_numeric(Xp, Yp), 'xlim', xlim, 'ylim', ylim)

figure(2)
clf
draw_signature(sig.evaluate(X, Y), 'facecolor', 'blue', 'facealpha', 1);
%hold on
%draw_signature(sigp.evaluate(X, Y), 'facecolor', 'red', 'facealpha', 0.5);


%% SE(2)
tform = SE2Transform(1, 0.1, -0.2);
sig = SE2_signature(f);
figure(1)
clf
draw_signature(sig.evaluate(X, Y), 'facealpha', 0.5)

%% SA(2)
A = [0.7, 1.1;
    -0.6, 0.8];


A = A / det(A);
tform = SA2Transform(A(1,1), A(1,2), A(2,1), A(2,2), 0.1, -0.2);
sig = SA2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% A(2)
tform = A2Transform(0.7, 1.1, -0.6, 0.8, 0.1, -0.2);
sig = A2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% Mobius
% Use plotting from under PSL3R block
tform = MobiusTransform(1.1, 0.2, 0.1, 0.2);
%tform = MobiusTransform(1, 0, 0, 0);
[xp, yp] = tform.reverse(x, y);
[Xp, Yp] = tform.reverse(X, Y);

sig = Mobius_signature(f);
sigp = Mobius_signature(f(xp, yp));

S1 = sig.evaluate(X, Y);
S2 = sigp.evaluate(X, Y);

%% PSL(3, R)
tform = PSL3RTransform(1, 0.1, 0.05, 0.8, 0.2, -0.1);

[Xp, Yp] = tform.reverse(X, Y); % arrays
[xp, yp] = tform.reverse(x, y); %symbolic
sig = PSL3R_signature(f);
sigp = PSL3R_signature(f(xp, yp));

S1 = sig.evaluate(X, Y);
S2 = sigp.evaluate(X, Y);
%%
figure(1)
clf
subplot(1,2,1)
draw_image(f_numeric(X, Y), 'xlim', xlim, 'ylim', ylim)
subplot(1,2,2)
draw_image(f_numeric(Xp, Yp), 'xlim', xlim, 'ylim', ylim)
%%
figure(2)
clf
draw_signature(sig.evaluate(X, Y), 'facecolor', 'blue', 'facealpha', 0.5);
hold on
draw_signature(sigp.evaluate(X, Y), 'facecolor', 'blue', 'facealpha', 0.5);
set(gcf, 'renderer', 'painters')
%%
figure(3);
clf
%level_min = min(min([S1{2} S2{2}]));
%level_max = max(max([S1{2} S2{2}]));
%levels = linspace(level_min, level_max, 10);
contour(S1{2}, S1{3}, S1{1}, levels, 'r');
hold on
contour(S2{2}, S2{3}, S2{1}, levels, 'b');

%% Mobius
