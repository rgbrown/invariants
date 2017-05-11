function draw_image(F, varargin)

params = parse_inputs(varargin{:});

[ny, nx] = size(F);
if ~isempty(params.xlim)
    x = linspace(params.xlim(1), params.xlim(2), nx);
else
    x = 1:nx;
end
if ~isempty(params.ylim)
    y = linspace(params.ylim(1), params.ylim(2), ny);
else
    y = 1:ny;
end
imagesc(x, y, F, params.clim)
axis image
colormap(params.cmap);
end

function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('xlim', []);
p.addParameter('ylim', []);
p.addParameter('clim', [0 1]);
p.addParameter('cmap', gray(65536));
p.parse(varargin{:});
params = p.Results;
end