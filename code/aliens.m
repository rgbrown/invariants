I1 = load_image('../images/fruit/view1c.png');
I2 = load_image('../images/fruit/view3c.png');
addpath packages
addpath signatures
I1 = I1/255;
I2 = I2/255;
I1(1, 1) = I1(1, 2);
I2(end, end) = I2(end-1, end);
x_filt = (-100:100);
y_filt = (-100:100);

[X_filter, Y_filter] = meshgrid(x_filt, y_filt);
normalise = @(x) x / sum(x(:));
makefilter = @(sigma) normalise(exp(-(abs(X_filter).^2 + abs(Y_filter).^2) ./ (2*sigma^2)));
filt_radius = 20;
K = makefilter(filt_radius);
I1_smooth = conv_fft2(I1, K, 'valid');
I2_smooth = conv_fft2(I2, K, 'valid');
%%
figure(1);
clf
subplot(1, 2, 1)
imagesc(I1_smooth)
axis equal
axis off
colormap(gray(65536));
subplot(1,2,2)
imagesc(I2_smooth)
axis equal
axis off
colormap(gray(65536));

%%
addpath('signatures');
sigfun = @E2_signature;
sig1 = sigfun(I1_smooth);
sig2 = sigfun(I2_smooth);

%%
figure(2)
clf
surf(sig1{1}, sig1{2}, sig1{3}, 'facecolor', 'blue', 'edgecolor', 'none', 'facealpha', 0.5);
hold on
surf(sig2{1}, sig2{2}, sig2{3}, 'facecolor', 'red', 'edgecolor', 'none', 'facealpha', 0.5);

%% Get input points, then plot on figure
figure(1)
[x, y] = ginput(2);
i1 = round(y(1));
j1 = round(x(1));
i2 = round(y(2));
j2 = round(x(2));


figure(2)
plot3(sig1{1}(i1,j1), sig1{2}(i1,j1), sig1{3}(i1,j1), 'y.', 'markersize', 24)
plot3(sig2{1}(i2,j2), sig2{2}(i2,j2), sig2{3}(i2,j2), 'g.', 'markersize', 24)





% %%
% figure(3)
% val = 0.1;
% clf
% contour(sig1{2}, sig1{3}, sig1{1}, [val val], 'r')
% hold on
% contour(sig2{2}, sig2{3}, sig2{1}, [val val], 'b')



%%
