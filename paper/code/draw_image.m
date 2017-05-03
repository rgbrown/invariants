function draw_image(f, varargin)
params = parse_inputs(varargin{:});
[X, Y, x, y] = regular_grid(...
    params.xlim(1), params.xlim(2), params.nx, ...
    params.ylim(1), params.ylim(2), params.ny);
f_numeric = matlabFunction(f);
imagesc(x, y, f_numeric(X, Y), params.clim)
axis image
colormap(params.cmap);
end

function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('nx', 1000);
p.addParameter('ny', 1000);
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('clim', [0 1]);
p.addParameter('cmap', gray(65536));
p.parse(varargin{:});
params = p.Results;
end