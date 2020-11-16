%% Projective invariant for different views of a 3D object
% This one should be interesting. We know that if you take two different
% perspective camera views of a plane, that the resulting images are mapped
% by a homography/projective transformation.
%
% However, because a smooth 3D object has a tangent plane, we feel that our
% projective invariant signature should actually work for views of any
% smooth 3D object with different views.
%
% The approach I'll take is to do this completely programmatically. I'll
% take a perspective view of a 3D object (chosen to avoid any occlusion)
% that has been somewhat randomly coloured, and then compute the signature
% of the thing. 

%% Setting up the object
% We'll define the object to live in 3D space, somewhat on the x/y plane.
% We'll take views of it from positive z, and different x, y coordinates.
% May as well use our 3D object from our example
%
x = linspace(-1, 1, 1000);
y = linspace(-1, 1, 1000);
[X, Y] = meshgrid(x, y);
Z = 0.5*exp(-2*X.^2 - 4.*sin((Y + 0.5*X.^2)).^2);
C = 0.5*(1 + cos(4*X.^2 + 7*Y)) + Y.^3;
surf(X, Y, Z, C, 'edgecolor', 'none');
colormap(gray(1024768))
axis equal
set(gca, 'projection', 'perspective')