%% Set up the function
% We create a symbolic and a numeric version of the function, for future
% reference.
addpath signatures
addpath transforms
syms x y
%f(x, y) = 0.01*(x - 1.5).^3 -0.02*(x - 1.5).^2.*(y + 1) + ...
%    0.03*(x - 1.5)*(y + 1).^2 - 0.015*(y + 1).^3 + 0.9;
f(x, y) = exp(-2*x.^2 - 4.*sin((y + 0.5*x.^2)).^2);
%f(x, y) = 0.6*(exp(-2*x.^2 - 0.5*x.*y - 4*y.^2) + 0.5 + 0.5*sin(2*(x + y)));
%f(x, y) = 0.4 + 0.1*x - 0.15*y + 0.2*x.^2 - 0.2*y.^2 - 0.1*x.*y + ...
%    0.015*x.^3 - 0.02*x.^2.*y + 0.01*x.*y.^2 - 0.03*y.^3;



%% Define all of the signatures and transformations
signatures.E2.tform = E2Transform(1, -1, 0.1, -0.2);
signatures.E2.sigfun = @E2_signature;
signatures.SE2.tform = SE2Transform(1, 0.1, -0.2);
signatures.SE2.sigfun = @SE2_signature;
signatures.Sim2.tform = Sim2Transform(1, 1, 0.1, -0.2, 1.4);
signatures.Sim2.sigfun = @Sim2_signature;
A = [0.7, 1.1;
    -0.6, 0.8];
A = A / sqrt(det(A));
signatures.SA2.tform = SA2Transform(A(1,1), A(1,2), A(2,1), A(2,2), 0.1, -0.2);
signatures.SA2.sigfun = @SA2_signature;
signatures.A2.tform = A2Transform(0.7, 1.1, -0.6, 0.8, 0.1, -0.2);
signatures.A2.sigfun = @A2_signature;
signatures.Mobius.tform = MobiusTransform(1.1, 0.2, 0.1, 0.2);
signatures.Mobius.sigfun = @Mobius_signature;
signatures.PSL3R.tform = PSL3RTransform(1, 0.1, 0.05, 0.8, 0.2, -0.1);
signatures.PSL3R.sigfun = @PSL3R_signature;
signatures.Diffcon.tform = DiffconTransform(2);
signatures.Diffcon.sigfun = @Diffcon_signature;


%% Try out a particular group, and then save 3D axes info using the block below
signatures.Diffcon.tform = DiffconTransform(2);
signatures.Diffcon.sigfun = @Diffcon_signature;
close all
group = 'Diffcon';
write_images = false;
close all
sig = generate_figures(f, signatures.(group), write_images);

%% Save group=specific axes to file
% Run this after generating a particular set of images to make sure they
% are saved for next time that group is drawn
sig.save_camera()
caminfo = sig.camera_info;
save(strcat('images/', sig.group, '_cam.mat'), 'caminfo');

%% Generate all images
write_images = true;
%groups = {'SE2', 'E2', 'Sim2', 'SA2', 'A2', 'Mobius', 'PSL3R', 'Conformal'};
groups = {'Diffcon'};
for k = 1:numel(groups)
    gp = groups{k};
    sig = generate_figures(f, signatures.(gp), write_images);
end

% Now run the script copyfigures.sh to trim the images and copy them to the 
% paper directory

%%
function sig = generate_figures(f, gp, write_images)
% Draw an image of the function
sigfun = gp.sigfun;
tform = gp.tform;

figure(1)
sig = sigfun(f);
sig.draw_image('showscanlines', false)

% Draw a before and after of the transformation with grid lines marked
sigp = sigfun(f, 'tform', tform);

if write_images
    figure(2)
    sig.draw_image()
    set(gcf, 'WindowState', 'maximized')
    print('-r200', '-dpng', strcat('images/', sig.group, '_before.png'));
    clf()
    sigp.draw_image()
    print('-r200', '-dpng', strcat('images/f_transformed_', sig.group));
else
    subplot(1,2,1)
    sig.draw_image()
    subplot(1,2,2)
    sigp.draw_image()
end

% Draw the signature surface with gridlines
surfopts = {'facecolor', 'blue', 'facealpha', 1, 'nx', 500, 'ny', 500, 'showscanlines', true};
figure(3)
sig.draw(surfopts{:})
% If there is a saved configuration of camera/light data, load and apply it
try
    load(strcat('images/', sig.group, '_cam.mat'));
    caminfo.apply()
end
if write_images
    set(gcf, 'WindowState', 'maximized')
    axis off
    print('-r200', '-dpng', strcat('images/', sig.group, '_signature.png'));
end

% Draw the two figures overlaid
surfopts = {'facealpha', 0.5, 'nx', 500, 'ny', 500, 'showscanlines', false};
figure(4)
sig.draw('facecolor', 'blue', surfopts{:});
hold on
sigp.draw('facecolor', 'red', surfopts{:});
hold off
% If there is a saved configuration of camera/light data, load and apply it
try
    load(strcat('images/', sig.group, '_cam.mat'));
    caminfo.apply()
end
if write_images
    set(gcf, 'WindowState', 'maximized')
    axis off
    print('-r200', '-dpng', strcat('images/', sig.group, '_match.png'));
end




end
