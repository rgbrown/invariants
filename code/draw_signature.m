function h = draw_signature(F, varargin)
params = parse_inputs(varargin{:});
x = linspace(params.xlim(1), params.xlim(2), params.nx);
y = linspace(params.ylim(1), params.ylim(2), params.ny);
[X, Y] = meshgrid(x, y);
[I0, I1, I2] = F(X, Y);
surf(I0, I1, I2, 'facecolor', params.facecolor, ...
    'edgecolor', 'none', ...
    'facealpha', params.facealpha);
camlight()
h = gca();
cameratoolbar();
set(gca, 'fontsize', 16, 'TickLabelInterpreter', 'latex')
xlabel('$I_1$', 'interpreter', 'latex')
ylabel('$I_2$', 'interpreter', 'latex')
zlabel('$I_3$', 'interpreter', 'latex')
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