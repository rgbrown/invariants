function [X, Y, x, y] = regular_grid(xmin, xmax, nx, ymin, ymax, ny)
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[X, Y] = meshgrid(x, y);