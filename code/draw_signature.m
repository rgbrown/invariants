function draw_signature(sig, varargin)
params = parse_inputs(varargin{:});
surf(sig{2}, sig{3}, sig{1}, 'facecolor', params.color, 'edgecolor', 'none')
camlight()
end

function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('nx', 1000);
p.addParameter('ny', 1000);
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('color', 'blue')
p.parse(varargin{:})
params = p.Results;
end