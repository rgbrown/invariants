%% Signature surface pictures
% Script file to create nice signature surface pictures
%

%% Test function
% Same function as in the Mobius  paper
f = @(x, y) exp(-4*x.^2 -8*(y-0.2*x - 0.8*x.^2).^2);

%%
% Set the colormap for all figures
cmap = hot(65536);

%% Construct the invariant object
% This is an object that stores the function and step size, and has methods
% to compute all of the things that we are interested in (signatures etc).
% The image is depicted below. Note you can modify 'h' later
foo = ImageInvariant(f, 'h', 0.001);
imshow(foo.evaluate())
colormap(cmap)

%% SE2 signature surface
% Just computes the signature using function value S0, $f_x + f_x$ (S1), and
% $f_{xx} + f_{yy}$ (S2)
figure(1)
clf
foo.h = 0.005;
[S0, S1, S2] = foo.SE2_signature();
surf(S1, S2, S0, 'edgecolor', 'none', 'facealpha', 0.9)
%axis off
colormap('default')
camlight
lighting('phong')
shading('interp')

%% Sim2 signature surface
% Just computes the signature using function value S0, $f_x + f_x$ (S1), and
% $f_{xx} + f_{yy}$ (S2)
figure(1)
clf
foo.h = 0.005;
[S0, S1, S2] = foo.Sim2_signature();
surf(S1, S2, S0, 'edgecolor', 'none', 'facealpha', 0.9)
axis('equal')
colormap('default')
camlight
lighting('phong')
shading('interp')

%% SA2 signature surface
figure(2)
clf
foo.h = 0.005;
[S0, S1, S2] = foo.SA2_signature();
surf(S1, S2, S0, 'edgecolor', 'none', 'facealpha', 0.9)
%axis off
colormap(cmap)
camlight
lighting('phong')
shading('interp')

%% Mobius signature surface
% S0 is the function value, S1, S2 are the two polar coordinate angles of
% the invariants projected to the unit sphere (as in dis.pdf), S3 and S4
% are the ones involving curl and divergence
figure(3)
clf
foo.h = 0.005;
tol = 0;
[S0, S1, S2, S3, S4] = foo.mobius_signature(tol);
surf(S1, S2, S0, 'edgecolor', 'none', 'facealpha', 0.9)
%axis off
colormap(cmap)
camlight
lighting('phong')
shading('interp')

%%
% Check that Mobius is working right (reproduce figures from paper)
[F, X, Y] = foo.evaluate();

figure(4)
contour(X, Y, real(F), linspace(.1, .9 ,9), 'blue')
hold on
contour(X, Y, real(S3), [-100, -1, -0.25], 'red')
contour(X, Y, real(S3), [0 0], 'green')
contour(X, Y, real(S3), [0.25, 1, 100], 'black')
axis('equal')

contour_levels = [0.2, 0.4, 0.6, 0.8];
figure(5)
contour(S3, S4, S0, contour_levels)
axis([-2,2,-2,2])

%% signature visualisation experiment
foo.h = 0.005;
F0 = foo.evaluate();
[S0, S1, S2] = foo.Sim2_signature();
visualise_signature_points(F0, S1, S2, S0)

%% Projective
foo.h = 0.005;
[S0, S1, S2, S3] = foo.PSL3R_signature();


