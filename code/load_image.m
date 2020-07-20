function load_image(fname)
I = imread(fname);
F = double(I(:, :, 1))*0.2989 + ...
    double(I(:, :, 2))*0.5870 + ...
    double(I(:, :, 3))*0.1140;
F = flipud(F');

end