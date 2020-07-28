%% Signature surface generation script
addpath('signatures', 'transforms')
syms x y
write_images = false;

%% Set up the function
% We create a symbolic and a numeric version of the function, for future
% reference.
%f(x, y) = 0.01*(x - 1.5).^3 -0.02*(x - 1.5).^2.*(y + 1) + ...
%    0.03*(x - 1.5)*(y + 1).^2 - 0.015*(y + 1).^3 + 0.9;
f(x, y) = exp(-2*x.^2 - 4.*sin((y + 0.5*x.^2)).^2);
%f(x, y) = 0.6*(exp(-2*x.^2 - 0.5*x.*y - 4*y.^2) + 0.5 + 0.5*sin(2*(x + y)));
%c = [0.5, -0.2, -0.3, -0.5, 0.03, -0.4, 0.001, -0.0015, 0.002, 0.03];
%foo = @(x, y, c) c(1) + c(2)*x + c(3)*y + ...
%    c(4)*x.^2 + c(5)*x.*y + c(6)*y.^2 + ...
%    c(7)*x.^3 + c(8)*x.^2.*y + c(9)*x.*y.^2 + c(10)*y.^3;

%f(x, y) = foo(x, y, c);
f_numeric = matlabFunction(f);

%% Plot and write image
sig = E2_signature(f);

figure(1)
clf
sig.draw_image('showscanlines', false)
if write_images
    print('-dpng', '-r200', 'images/function.png')
end
figure(2)
clf
sig.draw_image()
if write_images
    print('-dpng', '-r200', 'images/function_scanlines.png')
end

%% Write signature picture
groups = {'E2', 'SE2', 'A2', 'Mobius', 'PSL3R', 'SA2', 'Sim2'};
for i = 1:numel(groups)
    load(strcat('images/', groups{i}, '_signature.mat'));
    clf
    sig.draw();
    print('-dpng', '-r200', strcat('images/', groups{i}, '_signature.png'));
end

%% Save signature to file
% Run one of the blocks below, manually position signature image and
% lighting, then this will save it as a .mat file in images/
sig.save_camera();
save(strcat('images/', sig.group, '_signature.mat'), 'sig');

%% Save transformed image to file
clf
sigp.draw_image()
print('-dpng', '-r200', strcat('images/f_transformed_', sigp.group, '.png'));
%% E(2)
% Visualise transformation
close all
tform = E2Transform(1, -1, 0.1, -0.2);
sig = E2_signature(f);
[xp, yp] = tform.reverse(x, y);
sigp = E2_signature(f, 'tform', tform);
sig.draw('facecolor', 'blue', 'facealpha', 0.3, 'nx', 200, 'ny', 200, 'showscanlines', false)
hold on
sigp.draw('facecolor', 'red', 'facealpha', 0.3, 'nx', 200, 'ny', 200, 'showscanlines', false)
hold off



%% SE(2)
close all
tform = SE2Transform(1, 0.1, -0.2);
sig = SE2_signature_new(f);
[xp, yp] = tform.reverse(x, y);
sigp = SE2_signature_new(f, 'tform', tform);
sig.draw('facecolor', 'blue', 'facealpha', 0.5, 'nx', 200, 'ny', 200)
sigp.draw('facecolor', 'red', 'facealpha', 0.5, 'nx', 200, 'ny', 200)
% group_experiment(f, tform, @SE2_signature, 'scanlines', {Xscan, Yscan});

%% SA(2)
close all
A = [0.7, 1.1;
    -0.6, 0.8];
A = A / sqrt(det(A));
tform = SA2Transform(A(1,1), A(1,2), A(2,1), A(2,2), 0.1, -0.2);
sig = SA2_signature(f);
[xp, yp] = tform.reverse(x, y);
sigp = SA2_signature(f, 'tform', tform);
sig.draw('scanparams', {'y', 'linewidth', 1})
%group_experiment(f, tform, @SA2_signature, 'scanlines', {Xscan, Yscan});

%% A(2)
close all
tform = A2Transform(0.7, 1.1, -0.6, 0.8, 0.1, -0.2);
sig = A2_signature(f);
[xp, yp] = tform.reverse(x, y);
sigp = A2_signature(f, 'tform', tform);
sig.draw()
%group_experiment(f, tform, @A2_signature, 'scanlines', {Xscan, Yscan});

%% Mobius
close all
tform = MobiusTransform(1.1, 0.2, 0.1, 0.2);
sig = Mobius_signature(f);
[xp, yp] = tform.reverse(x, y);
sigp = Mobius_signature(f, 'tform', tform);
sig.draw()
%group_experiment(f, tform, @Mobius_signature, 'scanlines', {Xscan, Yscan});
%tform = MobiusTransform(1, 0, 0, 0);

%% PSL(3, R)
close all
tform = PSL3RTransform(1, 0.1, 0.05, 0.8, 0.2, -0.1);
sig = PSL3R_signature(f);
[xp, yp] = tform.reverse(x, y);
sigp = PSL3R_signature(f, 'tform', tform);
sig.draw();
%group_experiment(f, tform, @PSL3R_signature, 'scanlines', {Xscan, Yscan});

