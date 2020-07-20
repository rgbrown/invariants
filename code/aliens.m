

I1 = load_image('close1.jpg');
I2 = load_image('close2.jpg');

subplot(1, 2, 1)
imagesc(I1)
colormap(gray)
subplot(1,2,2)
imagesc(I2)
colormap(gray)

%%
x_filt = (-100:100);
y_filt = (-100:100);

[X_filter, Y_filter] = meshgrid(x_filt, y_filt);
normalise = @(x) x / sum(x(:));
makefilter = @(sigma) normalise(exp(-(abs(X_filter).^2 + abs(Y_filter).^2) ./ (2*sigma^2)));

K = makefilter(20);
I1_smooth = conv_fft2(I1, K, 'same');
I2_smooth = conv_fft2(I2, K, 'same');

subplot(1, 2, 1)
imagesc(I1_smooth)
colormap(gray)
subplot(1,2,2)
imagesc(I2_smooth)
colormap(gray(4096))