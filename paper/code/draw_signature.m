function draw_signature(sig, varargin)
params = parse_inputs(varargin{:});
[X, Y] = regular_grid(...
    params.xlim(1), params.xlim(2), params.nx, ...
    params.ylim(1), params.ylim(2), params.ny);
S = cell(1, 3);
for i = 1:3
    f_num = matlabFunction(sig{i});
    S{i} = f_num(X, Y);
end
surf(S{2}, S{3}, S{1}, 'facecolor', params.color, 'edgecolor', 'none')
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