%% E2 Real Image
% In this script, we show how the E(2) signature can be applied to real
% images by first using presmoothing by a Gaussian filter, a process which
% is itself Euclidean-invariant
addpath('signatures', 'transforms')


%% Load test image and set up coordinates
F = double(imread('kiwi.jpg')) / 255;
if size(F, 3) == 3
    F = rgb2gray(F);
end
nx = size(F, 2);
ny = size(F, 1);
x = linspace(-1, 1, nx);
y = linspace(-1, 1, ny);
dx = 2 / (nx - 1);
dy = 2 / (ny - 1);
%imshow(F)

interpolate = true;
if interpolate
    nxf = 6000;
    nyf = 6000;
    [X, Y] = meshgrid(x, y);
    xf = linspace(-1, 1, nxf);
    yf = linspace(-1, 1, nyf);
    dxf = 2 / (nxf - 1);
    dyf = 2 / (nyf - 1);
    [Xf, Yf] = meshgrid(xf, yf);
    Ff = interp2(X, Y, F, Xf, Yf, 'cubic');
    F = Ff;
    X = Xf;
    Y = Yf;
    x = xf;
    y = yf;
    nx = nxf;
    ny = nyf;
    dx = dxf;
    dy = dyf;
end
% Interpolate onto a finer mesh

%% Define a Euclidean transformation
theta = 1.1; 
determinant = -1; 
tx = -0.1; 
ty = 0.2;
tform = E2Transform(theta, determinant, tx, ty);

%% Transform our image
Fp = tform.forward(F, x, y);
Fp(isnan(Fp)) = 0;
imshow(Fp);

%% Set up the truncated Gaussian filter machinery
x_filt = (-500:500)*dx;
y_filt = (-500:500)*dy;

[X_filter, Y_filter] = meshgrid(x_filt, y_filt);
normalise = @(x) x / sum(x(:));
makefilter = @(sigma) normalise(exp(-(abs(X_filter).^2 + abs(Y_filter).^2) ./ (2*sigma^2)));

K = makefilter(0.01);
F_smooth = conv_fft2(F, K, 'same');
imshow(F_smooth)

%% Now perform the experiments
sigma_vals = linspace(0.001, 0.02, 9);
n = numel(sigma_vals);
sig = cell(1, n);
sigp = cell(1, n);
fprintf('progress (%d):', n);
for i = 1:n
    fprintf('%d ', i);
    sigma = sigma_vals(i);
    K = makefilter(sigma);
    F_smooth = conv_fft2(F, K, 'same');
    Fp_smooth = conv_fft2(Fp, K, 'same');
    sig{i} = E2_signature(F_smooth, dx);
    sigp{i} = E2_signature(Fp_smooth, dx);
    figure(1)
    subplot(3, 3, i);
    imshow(F_smooth)
    figure(2)
    subplot(3, 3, i);
    imshow(Fp_smooth)
    figure(3)
    subplot(3, 3, i);
    %surf(sig{i}{1}, sig{i}{2}, sig{i}{3}, 'facealpha', 0.5, 'edgecolor', 'none', 'facecolor', 'blue');
    contour(sig{i}{1}, sig{i}{2}, sig{i}{3}, [0.5 0.5], 'k', 'linewidth', 1);
    hold on
    contour(sigp{i}{1}, sigp{i}{2}, sigp{i}{3}, [0.5 0.5], 'r', 'linewidth', 1);
    %camlight()
    %axis off
    
end
fprintf('\n')

%%
% clf
% S = contour(sig{1}{1}, sig{1}{2}, sig{1}{3}, [0.5 0.5], 'r');
% hold on
% contour(sigp{1}{1}, sigp{1}{2}, sigp{1}{3}, [0.5 0.5], 'b');
% pause
% % surf(sigp{1}, sigp{2}, sigp{3}, 'facealpha', 0.5, 'edgecolor', 'none', 'facecolor', 'blue');
% for i = 1:numel(sig)
%     pause(0.05)
%     clf
%     contour(sig{i}{1}, sig{i}{2}, sig{i}{3}, [0.5 0.5], 'r');
%     hold on
%     contour(sigp{i}{1}, sigp{i}{2}, sigp{i}{3}, [0.5 0.5], 'b');
%     
% end


%%


% %% Greyscale signatures
% % Define the image function that we will use, and plot it
% f = @(x, y) exp(-4*x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
% npts = 500;
% [X, Y] = makegrid([-1, 1], [-1, 1], npts, npts);
% dx = 2 / (npts - 1);
% %%
% % Define a Euclidean transformation
% theta = 1.1; determinant = -1; tx = -0.1; ty = 0.2;
% tform = E2Transform(theta, determinant, tx, ty);
% 
% %%
% % Display image and its transformed version
% F = f(X, Y);
% [Xp, Yp] = tform.reverse(X, Y);
% Fp = f(Xp, Yp);
% subplot(1,2,1)
% imshow(F)
% subplot(1,2,2)
% imshow(Fp)
% %% Visualise signature
% surf_args = {'edgecolor', 'none', 'facealpha', 0.5};
% 
% sig = E2_signature(F, dx);
% sig1 = E2_signature(Fp, dx);
% 
% %surf(sig{1}, sig{2}, sig{3}, 'facecolor', 'red', surf_args{:});
% %hold on
% %surf(sig1{1}, sig1{2}, sig1{3}, 'facecolor', 'blue', surf_args{:});
% 
% levels = linspace(0, 1, 7);
% contour(sig{2}, sig{3}, sig{1}, levels, 'linewidth', 2, 'linecolor', 'blue')
% hold on
% contour(sig1{2}, sig1{3}, sig1{1}, levels, 'linewidth', 2, 'linecolor', 'red')
% 
% 
% %% Euclidean invariant smoothing
% % Set up filter
% nk = 60;
% xk = linspace(-0.3, 0.3, nk);
% yk = xk;
% [Xk, Yk] = meshgrid(xk, yk);
% sigma_k = .1;
% K = exp(-(Xk.^2 + Yk.^2) / (2*sigma_k^2));
% K = K / sum(K(:));
% 
% % Load image
% F = imread('images/lena.jpg');
% F = double(F) / 255;
% 
% % Image coordinates
% x = linspace(-1, 1, size(F, 2));
% y = linspace(-1, 1, size(F, 1));
% dx = mean(diff(x));
% [X, Y] = meshgrid(x, y);
% 
% % Transformed coordinates
% tform = E2Transform(1.1, -1, -0.1, 0.2);
% [X_irreg, Y_irreg] = tform.reverse(X, Y);
% Fp = interp2(X, Y, F, X_irreg,Y_irreg,'cubic');
% 
% % Smooth original
% F_smooth = conv2(F, K, 'same');
% 
% % Smooth transformed
% Fp_smooth = conv2(Fp, K, 'same');
% 
% % Invert transform, taking smoothed transformed back to original
% % coordinates
% [X_irreg, Y_irreg] = tform.forward(X, Y);
% Fp_smooth_inv = interp2(X, Y, Fp_smooth, X_irreg,Y_irreg,'cubic');
% 
% %%
% sig = E2_signature(F_smooth, dx);
% sig1 = E2_signature(Fp_smooth, dx);
% 
% figure(1)
% clf
% surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
% %hold on
% %surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);
% 
% figure(2)
% clf
% levels = [0.5 0.5];
% contour(sig{2}, sig{3}, sig{1}, levels, 'linewidth', 2, 'linecolor', 'blue')
% hold on
% contour(sig1{2}, sig1{3}, sig1{1}, levels, 'linewidth', 2, 'linecolor', 'red')
% %% Colour stuff
% % Image coordinates
% x = linspace(-1, 1, size(F, 2));
% y = linspace(-1, 1, size(F, 2));
% dx = mean(diff(x));
% [X, Y] = meshgrid(x, y);
% smoother = @(x) conv2(x, K, 'same');
% [lena_col, map] = imread('lena_color.gif');
% red = map(:, 1);
% green = map(:, 2);
% blue = map(:, 3);
% Fred = red(lena_col + 1);
% Fgreen = green(lena_col + 1);
% Fblue = blue(lena_col + 1);
% F1 = conv2(Fred, K, 'same');
% F2 = conv2(Fgreen, K, 'same');
% F3 = conv2(Fblue, K, 'same');
% 
% tform = E2Transform(1.1, -1, -0.1, 0.2);
% [X_irreg, Y_irreg] = tform.reverse(X, Y);
% F1p = smoother(interp2(X, Y, Fred, X_irreg,Y_irreg,'cubic'));
% F2p = smoother(interp2(X, Y, Fgreen, X_irreg,Y_irreg,'cubic'));
% F3p = smoother(interp2(X, Y, Fblue, X_irreg,Y_irreg,'cubic'));
% 
% 
% sig = E2_colour_signature(F1, F2, dx);
% sig1 = E2_colour_signature(F1p, F2p, dx);
% 
% figure(1)
% clf
% surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
% hold on
% surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);
% 
% 
% 
% 
% 
% %%
% 
% F_filt = conv2(F, K, 'same');
% figure(1)
% colormap(gray(65536))
% subplot(1, 2, 1)
% imagesc(F_smooth)
% axis image
% subplot(1,2,2)
% imagesc(Fp_smooth_inv)
% axis image
% 
% figure(2)
% mask = X > -0.5 & X < 0.5 & Y > -0.5 & Y < 0.5
% imagesc(Fp_smooth_inv(200:400, 200:400) - F_smooth(200:400, 200:400))
% colorbar()



