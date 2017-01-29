%% E(2) Greyscale Reconstruction
% We use the E(2) signature $(f, f_i f_i, f_ii)$ to compute signatures for
% first synthetic, and then real, images

%% Utility functions
makegrid = @(xlim, ylim, nx, ny) ...
    meshgrid(linspace(xlim(1), xlim(2), nx), ...
    linspace(ylim(1), ylim(2), ny));

%% Greyscale signatures
% Define the image function that we will use, and plot it
f = @(x, y) exp(-4*x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
npts = 500;
[X, Y] = makegrid([-1, 1], [-1, 1], npts, npts);
dx = 2 / (npts - 1);
%%
% Define a Euclidean transformation
theta = 1.1; determinant = -1; tx = -0.1; ty = 0.2;
tform = E2Transform(theta, determinant, tx, ty);

%%
% Display image and its transformed version
F = f(X, Y);
[Xp, Yp] = tform.reverse(X, Y);
Fp = f(Xp, Yp);
subplot(1,2,1)
imshow(F)
subplot(1,2,2)
imshow(Fp)
%% Visualise signature
surf_args = {'edgecolor', 'none', 'facealpha', 0.5};

sig = E2_signature(F, dx);
sig1 = E2_signature(Fp, dx);

%surf(sig{1}, sig{2}, sig{3}, 'facecolor', 'red', surf_args{:});
%hold on
%surf(sig1{1}, sig1{2}, sig1{3}, 'facecolor', 'blue', surf_args{:});

levels = linspace(0, 1, 7);
contour(sig{2}, sig{3}, sig{1}, levels, 'linewidth', 2, 'linecolor', 'blue')
hold on
contour(sig1{2}, sig1{3}, sig1{1}, levels, 'linewidth', 2, 'linecolor', 'red')


%% Euclidean invariant smoothing
% Set up filter
nk = 60;
xk = linspace(-0.3, 0.3, nk);
yk = xk;
[Xk, Yk] = meshgrid(xk, yk);
sigma_k = .1;
K = exp(-(Xk.^2 + Yk.^2) / (2*sigma_k^2));
K = K / sum(K(:));

% Load image
F = imread('images/lena.jpg');
F = double(F) / 255;

% Image coordinates
x = linspace(-1, 1, size(F, 2));
y = linspace(-1, 1, size(F, 1));
dx = mean(diff(x));
[X, Y] = meshgrid(x, y);

% Transformed coordinates
tform = E2Transform(1.1, -1, -0.1, 0.2);
[X_irreg, Y_irreg] = tform.reverse(X, Y);
Fp = interp2(X, Y, F, X_irreg,Y_irreg,'cubic');

% Smooth original
F_smooth = conv2(F, K, 'same');

% Smooth transformed
Fp_smooth = conv2(Fp, K, 'same');

% Invert transform, taking smoothed transformed back to original
% coordinates
[X_irreg, Y_irreg] = tform.forward(X, Y);
Fp_smooth_inv = interp2(X, Y, Fp_smooth, X_irreg,Y_irreg,'cubic');

%%
sig = E2_signature(F_smooth, dx);
sig1 = E2_signature(Fp_smooth, dx);

figure(1)
clf
surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
%hold on
%surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);

figure(2)
clf
levels = [0.5 0.5];
contour(sig{2}, sig{3}, sig{1}, levels, 'linewidth', 2, 'linecolor', 'blue')
hold on
contour(sig1{2}, sig1{3}, sig1{1}, levels, 'linewidth', 2, 'linecolor', 'red')
%% Colour stuff
% Image coordinates
x = linspace(-1, 1, size(F, 2));
y = linspace(-1, 1, size(F, 2));
dx = mean(diff(x));
[X, Y] = meshgrid(x, y);
smoother = @(x) conv2(x, K, 'same');
[lena_col, map] = imread('lena_color.gif');
red = map(:, 1);
green = map(:, 2);
blue = map(:, 3);
Fred = red(lena_col + 1);
Fgreen = green(lena_col + 1);
Fblue = blue(lena_col + 1);
F1 = conv2(Fred, K, 'same');
F2 = conv2(Fgreen, K, 'same');
F3 = conv2(Fblue, K, 'same');

tform = E2Transform(1.1, -1, -0.1, 0.2);
[X_irreg, Y_irreg] = tform.reverse(X, Y);
F1p = smoother(interp2(X, Y, Fred, X_irreg,Y_irreg,'cubic'));
F2p = smoother(interp2(X, Y, Fgreen, X_irreg,Y_irreg,'cubic'));
F3p = smoother(interp2(X, Y, Fblue, X_irreg,Y_irreg,'cubic'));


sig = E2_colour_signature(F1, F2, dx);
sig1 = E2_colour_signature(F1p, F2p, dx);

figure(1)
clf
surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
hold on
surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);





%%

F_filt = conv2(F, K, 'same');
figure(1)
colormap(gray(65536))
subplot(1, 2, 1)
imagesc(F_smooth)
axis image
subplot(1,2,2)
imagesc(Fp_smooth_inv)
axis image

figure(2)
mask = X > -0.5 & X < 0.5 & Y > -0.5 & Y < 0.5
imagesc(Fp_smooth_inv(200:400, 200:400) - F_smooth(200:400, 200:400))
colorbar()



