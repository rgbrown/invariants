%% Creating pictures of smooth objects (no, not that kind)

%% Option 1: Stripy sphere

theta = linspace(-pi, pi, 500);
phi = linspace(-pi/2, pi/2, 500);
r = 1;

[Theta, Phi] = meshgrid(theta, phi);
X = r*cos(Theta).*cos(Phi);
Y = r*sin(Theta).*cos(Phi);
Z = r*sin(Phi);
C = 0.5*(1 + cos(4*(pi/2 + Phi)));

%% Option 2

theta = linspace(-pi, pi, 500);
phi = linspace(-pi/2, pi/2, 500);


[Theta, Phi] = meshgrid(theta, phi);
R = 1 + 0.1*cos(3*Theta);
X = R.*cos(Theta).*cos(Phi);
Y = R.*sin(Theta).*cos(Phi);
Z = sin(Phi);
C = 0.5*(1.2 + 0.2*sin(5*Theta) + cos(4*(pi/2 + Phi)));
%%

surf(X, Y, Z, C, 'edgecolor', 'none');
colormap(gray(65536));
xlabel('X');
ylabel('Y');
zlabel('Z');
set(gca, 'projection', 'perspective');
axis off
axis equal