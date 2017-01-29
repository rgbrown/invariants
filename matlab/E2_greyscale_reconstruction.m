%% E(2) Section
%

%% Real image
% Load image
F = imread('images/lena.jpg');
F = double(F) / 255;

%% Blur and transform 
x = linspace(-1, 1, size(F, 2));
y = linspace(-1, 1, size(F, 1));
[X, Y] = meshgrid(x, y);
dx = mean(diff(x));
tform = E2Transform(1.1, -1, -0.1, .2);
[X_irreg, Y_irreg] = tform.reverse(X, Y);

% Transform image
Fp = interp2(X, Y, F, X_irreg, Y_irreg,'cubic');  
Fp(isnan(Fp)) = 0;

SIGMA = [10:10:100];
n = numel(SIGMA);
dx = 2 / size(F, 2);
nk = 200;
for i = 1:n
    sigma = SIGMA(i);
    K = gaussian_filter(sigma, nk);
    
    F_filtered = conv2(F, K, 'same');
    Fp_filtered = conv2(Fp, K, 'same');
    
    sig{i} = E2_signature(F_filtered, dx);
    sigp{i} = E2_signature(Fp_filtered, dx);
    
    s = sig{i};
    sp = sigp{i};
    
    clf()
    surf(s{1}, s{2}, s{3}, 'facecolor', 'red', 'edgecolor', 'none', 'facealpha', 0.5)
    camlight()
    
    print('-dpng', '-r200', sprintf('figures/siglenaE2%02d.png', i));
    clf()
    surf(sp{1}, sp{2}, sp{3}, 'facecolor', 'red', 'edgecolor', 'none', 'facealpha', 0.5)
    camlight()
    print('-dpng', '-r200', sprintf('figures/sigplenaE2%02.png', i));
    
end

%% Create E(2) signatures of all images
myimread = @(name) double(imread(name)) / 255;


for i = 1:1
    dx = 2/size(F,2);
    sig{i} = E2_signature(F, dx);
    sigp{i} = E2_signature(Fp, dx);
    s = sig{i};
    sp = sigp{i};
    clf()
    surf(s{1}, s{2}, s{3}, 'facecolor', 'red', 'edgecolor', 'none', 'facealpha', 0.5)
    camlight()
    
    print('-dpng', '-r200', sprintf('figures/siglenaE2%02.png', i));
    clf()
    surf(sp{1}, sp{2}, sp{3}, 'facecolor', 'red', 'edgecolor', 'none', 'facealpha', 0.5)
    camlight()
    print('-dpng', '-r200', sprintf('figures/sigplenaE2%02.png', i));
end

%% image
syms x y
f_sym(x, y) = exp(-4*x.^2 -8*(y - 0.2*x - 0.8*x.^2).^2);
f = matlabFunction(f_sym);

npts = 500;
x = linspace(-1, 1, npts);
dx = 2 / (npts - 1);
y = x;
[X, Y] = meshgrid(x, y);

I = f(X, Y);
figure(1)
imshow(I)
%% Construct the ****ing images
F = f(X, Y);
tform = E2Transform(1.1, -1, -0.1, 0.2);
[Xp, Yp] = tform.reverse(X, Y);
Fp = f(Xp, Yp);

%% Visualise signature
sig = E2_signature(F, dx);
sig1 = E2_signature(Fp, dx);

surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
hold on
surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);

%% Euclidean invariant smoothing
% Set up filter

%%
sig = E2_signature(F_smooth, dx);
sig1 = E2_signature(Fp_smooth, dx);

surf(sig{1}, sig{2}, sig{3}, 'edgecolor', 'none', 'facecolor', 'red', 'facealpha', 0.5);
%hold on
%surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);


%% Colour stuff
% Image coordinates
x = linspace(-1, 1, 512);
y = linspace(-1, 1, 512);
dx = mean(diff(x));
[X, Y] = meshgrid(x, y);
smoother = @(x) conv2(x, K, 'same');
[lena_col, map] = imread('images/lena_color.gif');
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
camlight()
%hold on
%surf(sig1{1}, sig1{2}, sig1{3}, 'edgecolor', 'none', 'facecolor', 'blue', 'facealpha', 0.5);





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



