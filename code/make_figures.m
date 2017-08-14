%% Signature surface generation script
addpath('signatures', 'transforms')
syms x y
write_images = false;

%% Set up the function
% We create a symbolic and a numeric version of the function, for future
% reference.

%f(x, y) = exp(-2*x.^2 - 4.*sin((y + 0.5*x.^2)).^2);
f(x, y) = 0.6*(exp(-2*x.^2 - 0.5*x.*y - 4*y.^2) + 0.5 + 0.5*sin(2*(x + y)));
f_numeric = matlabFunction(f);

xlim = [-1, 1];
ylim = [-1, 1];

draw_image(f_numeric, 'xlim', xlim, 'ylim', ylim);

% Set up scan lines
nlines = 21;
xscan = linspace(-1, 1, nlines);
yscan = linspace(-1, 1, nlines); 
nscan = 1000;
t = linspace(-1, 1, nscan);
Xscan = zeros(nscan, 2*nlines);
Yscan = zeros(size(Xscan));
for i = 1:nlines
    Xscan(:, i) = t;
    Yscan(:, i) = yscan(i);
end
for i = 1:numel(xscan)
    Xscan(:, i + nlines) = xscan(i);
    Yscan(:, i + nlines) = t;
end


%% Write signature picture
% Run one of the blocks below, manually position signature image (Fig 2)
% for lighting, and then execute this block
axis off
print(1, '-r200', '-dpng', strcat('images/', class(tform), '_transform.png'))
print(2, '-r200', '-dpng', strcat('images/', class(tform), '_signature.png'))


%% E(2)
% Visualise transformation
close all
tform = E2Transform(1, -1, 0.1, -0.2);
group_experiment(f, tform, @E2_signature, 'scanlines', {Xscan, Yscan});


%% SE(2)
close all
tform = SE2Transform(1, 0.1, -0.2);
group_experiment(f, tform, @SE2_signature, 'scanlines', {Xscan, Yscan});

%% SA(2)
close all
A = [0.7, 1.1;
    -0.6, 0.8];
A = A / sqrt(det(A));
tform = SA2Transform(A(1,1), A(1,2), A(2,1), A(2,2), 0.1, -0.2);
group_experiment(f, tform, @SA2_signature, 'scanlines', {Xscan, Yscan});

%% A(2)
close all
tform = A2Transform(0.7, 1.1, -0.6, 0.8, 0.1, -0.2);
group_experiment(f, tform, @A2_signature, 'scanlines', {Xscan, Yscan});

%% Mobius
close all
tform = MobiusTransform(1.1, 0.2, 0.1, 0.2);
group_experiment(f, tform, @Mobius_signature, 'scanlines', {Xscan, Yscan});
%tform = MobiusTransform(1, 0, 0, 0);

%% PSL(3, R)
close all
tform = PSL3RTransform(1, 0.1, 0.05, 0.8, 0.2, -0.1);
group_experiment(f, tform, @PSL3R_signature, 'scanlines', {Xscan, Yscan});

