function draw_image(F, varargin)
params = parse_inputs(varargin{:});
x = linspace(params.xlim(1), params.xlim(2), params.nx);
y = linspace(params.ylim(1), params.ylim(2), params.ny);
if ~isnumeric(F)
    [X, Y] = meshgrid(x, y);
    F = F(X, Y);
end    
imagesc(x, y, F, params.clim)
axis image
colormap(params.cmap);
end

function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('nx', 2000);
p.addParameter('ny', 2000);
p.addParameter('clim', [0 1]);
p.addParameter('cmap', gray(65536));
p.parse(varargin{:});
params = p.Results;
end