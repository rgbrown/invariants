%% Signature surface generation script
addpath('signatures', 'transforms')
syms x y
write_images = false;

%% Set up the function
% We create a symbolic and a numeric version of the function, for future
% reference.
%f(x, y) = 0.01*(x - 1.5).^3 -0.02*(x - 1.5).^2.*(y + 1) + ...
 %   0.03*(x - 1.5)*(y + 1).^2 - 0.015*(y + 1).^3 + 0.9;
%f(x, y) = exp(-2*x.^2 - 4.*sin((y + 0.5*x.^2)).^2);
%f(x, y) = 0.6*(exp(-2*x.^2 - 0.5*x.*y - 4*y.^2) + 0.5 + 0.5*sin(2*(x + y)));
f(x, y) = 0.5 - 0.2*x - 0.3*y - 0.05*x.^2 + 0.03*x.*y + 0.04*y.^2 + ...
    0.03*y.^3 +0.001*x.^3 - 0.0015*x.^2.*y + 0.002*x.*y.^2 - 0.0005*y.^3;

%% Plot and write image
clf
sig = E2_signature(f);
sig.draw_image('showscanlines', false)
print('-dpng', '-r200', 'images/function.png')
clf
sig.draw_image()
print('-dpng', '-r200', 'images/function_scanlines.png')

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





%% SE(2)
close all
tform = SE2Transform(1, 0.1, -0.2);
sig = SE2_signature(f);
[xp, yp] = tform.reverse(x, y);
sigp = SE2_signature(f, 'tform', tform);
sig.draw()
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
sig.draw()
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

