%% Figures for the NZMS colloquium talk
% First we need to define our function
h = 0.005;
f = @(x, y) 0.5 + 0.5*(sin(4*x).*cos(7*y)) .* exp(-10*((x - 0.1).^2 + (y+0.2).^2));

% Second colour channel
f1 = @(x, y) 0.5 + 0.5*(sin(5*x).*cos(3*y)) .* exp(-10*((x - 0.1).^2 + (y+0.1).^2));
[X, Y] = meshgrid(-1.5:h:1.5, -1.5:h:1.5);

G = f(X, Y);
B = f1(X, Y);
R = zeros(size(X));
Im = zeros(size(X, 1), size(X, 2), 3);
Im(:, :, 1) = R; Im(:, :, 2) = G; Im(:, :, 3) = B;
image(Im)

%% Generate a random conformal mapping
f_forward = random_mobius();
[Xn, Yn] = f_forward(X, Y);

%% Compute various signature derivatives
sig1 = SA2sig(h, f(X, Y));
sig2 = SA2sig(h, f(Xn, Yn));

%% Compute the colour images
G = f(X, Y); B = f1(X, Y); R = zeros(size(X));
Im = zeros(size(X, 1), size(X, 2), 3);
Im(:, :, 1) = R; Im(:, :, 2) = G; Im(:, :, 3) = B;

G1 = f(Xn, Yn); B1 = f1(Xn, Yn); R1 = zeros(size(X));
Im1 = zeros(size(X, 1), size(X, 2), 3);
Im1(:, :, 1) = R1; Im1(:, :, 2) = G1; Im1(:, :, 3) = B1;


%% Plot surfaces
cm = gray(16384);
figure(1)
surf(X, Y, f(X, Y), 'edgecolor', 'none')
colormap(cm)
shading('interp')
camlight()
axis off
%print -r200 -dpng 'surf_before.png'

figure(2)
surf(X, Y, f(Xn, Yn), 'edgecolor', 'none')
colormap(cm)
shading('interp')
camlight()
axis off
%print -r200 -dpng 'surf_after.png'

%% Plot grayscale images
figure(3)
imagesc(f(X, Y))
colormap(cm)
axis off
print -r200 -dpng 'image_before.png'
figure(4)
imagesc(f(Xn, Yn))
colormap(cm)
axis off
print -r200 -dpng 'image_after.png'

%% Draw signature surface
surf(sig1{2}, sig1{3}, sig1{1}, sig1{1}, 'edgecolor', 'none', 'facealpha', 0.5)

%% Draw contour plot
figure(6)
contour(sig1{2}, sig1{3}, sig1{1}, 'linewidth', 3)
colormap cool(16384)
set(gca, 'fontsize', 20)
xlabel('I_1')
ylabel('I_2')
colorbar()
%print -dpng -r200 'signature_contours.png'

%% Compare signature contours
figure(7)
clf
contour(sig1{2}, sig1{3}, sig1{1}, 'linewidth', 3, 'linecolor', 'blue')
hold on
contour(sig2{2}, sig2{3}, sig2{1}, 'linewidth', 3, 'linecolor', 'red')
colormap cool(16384)
set(gca, 'fontsize', 20)
xlabel('I_1')
ylabel('I_2')
%print -dpng -r200 'signatures_compared.png'

%% Plot colour images
figure(8)
subplot(1,2,1)
image(Im)
subplot(1,2,2)
image(Im1)
imwrite(Im, 'colour_before.jpg')
imwrite(Im1, 'colour_after.jpg')

%% Plot as surfaces
figure(9)
clf
surf(X, Y, G, 'facecolor', 'green', 'edgecolor', 'none', 'facealpha', 0.5)
camlight
shading interp
lighting phong
hold on
surf(X, Y, B, 'facecolor', 'blue', 'edgecolor', 'none', 'facealpha', 0.5)
view(-116, -18)
axis off
print -r200 -dpng 'colour_surfaces.png'