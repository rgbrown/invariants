I1 = load_image('images/view1.JPG');
I2 = load_image('images/view2.JPG');
addpath signatures
I1 = I1/255;
I2 = I2/255;

I1_smooth = gaussfilt(I1, 50);
I2_smooth = gaussfilt(I2, 50);

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
sigfun = @A2_signature;
sig1 = sigfun(I1_smooth, 1e-1);
sig2 = sigfun(I2_smooth, 1e-1);


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



function Is = gaussfilt(I, sigma)
x = (-6*ceil(sigma)):(6*ceil(sigma));
ker = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma^2));
ker = ker/sum(ker);
nfilt = numel(ker);
Is = filter(ker, 1, I, [], 1);
Is(1:nfilt-1, :) = [];
Is = filter(ker, 1, Is, [], 2);
Is(:, 1:nfilt-1) = [];
end
