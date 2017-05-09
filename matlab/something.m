%% Signature visualisation stuff

% Create some transformations

t_E2 = E2Transform(1.1, -1, 0.1, 0.2);
t_Sim2 = Sim2Transform(1.1, 0.1, 0.2, 0.8);
A = rand(2); 
A(1, :) = sign(det(A)) * A(1, :);
A = A / sqrt(det(A));
t_SA2 = A2Transform(A, [0.2; 0.1]);
t_PSL3R = PSL3RTransform(1, 0.1, 0.05, 0.8, 0.2, 0.3);
A = rand(2);
t_A2 = A2Transform(A, [0.2; 0.1]);

% Define our image function
%f = @(x, y) cos(exp(-((x + 0.2).^2 + (y + 0.6).^2)/(2*(0.6^2)))) + ...
%     exp(-((x - 0.4).^2 + (y - 0.8).^2)/(2*(0.6)^2));
f = @(x, y) exp(1*(-4*x.^2 - 8*(y - 0.2*x - 0.8*x.^2).^2));

%% Choose which one to use

tform = t_PSL3R;
sig_fun = @PSL3R_signature;

%% Plot the image, before and after transform
n = 1000;
x = linspace(-1, 1, n);
y = linspace(-1, 1, n);
h = 2 / (n - 1);
[X, Y] = meshgrid(x, y);

fp = tform.forward(f);

F = f(X, Y);
Fp = fp(X, Y);
figure(1);
clf
subplot(1,2,1)
imagesc(f(X, Y))
axis image
colormap(gray(65536));
subplot(1,2,2)
imagesc(fp(X, Y))
colormap(gray(65536));
axis image

%% Compute signatures and plot surface and contour maps
sig = sig_fun(F, h);
sigp = sig_fun(Fp, h);

figure(2)
clf
surf(sig{1}, sig{2}, sig{3}, 'facecolor', 'red', 'facealpha', 0.5, 'edgecolor', 'none')
hold on
surf(sigp{1}, sigp{2}, sigp{3}, 'facecolor', 'blue', 'facealpha', 0.5, 'edgecolor', 'none')
camlight()

figure(3)
levels = linspace(0, 1, 11);
clf
contour(sig{2}, sig{3}, sig{1}, 'k')
hold on
contour(sigp{2}, sigp{3}, sigp{1}, 'r:')
