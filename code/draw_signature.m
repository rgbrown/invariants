function draw_signature(sig, varargin)
params = parse_inputs(varargin{:});
surf(sig{2}, sig{3}, sig{1}, 'facecolor', params.facecolor, ...
    'edgecolor', 'none', ...
    'facealpha', params.facealpha)
camlight()
end

function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('nx', 1000);
p.addParameter('ny', 1000);
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('facecolor', 'blue')
p.addParameter('facealpha', 1);
p.parse(varargin{:})
params = p.Results;
end