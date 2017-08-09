function [sig, h] = visualise_signatures(f, sig_fun, varargin)
params = parse_inputs(varargin{:});
sig = sig_fun(f);
[X, Y] = regular_grid(params.xlim(1), params.xlim(2), params.nx, ...
    params.ylim(1), params.ylim(2), params.ny);

draw_signature(sig.evaluate(X, Y), 'facecolor', params.facecolor, ...
    'facealpha', params.facealpha);
h = gca();

% Draw signature of transformed function if a transformation has been
% provided
if ~isempty(params.tform)
    syms x y
    [xp, yp] = params.tform.reverse(x, y);
    sigp = sig_fun(f(xp, yp));
    tf = ishold;
    hold on
    draw_signature(sigp.evaluate(X, Y), 'facecolor', params.facecolor2, ...
        'facealpha', params.facealpha);
    if ~tf
        hold off
    end
end




end

function parameters = parse_inputs(varargin)
p = inputParser();
p.addParameter('tform', []);
p.addParameter('facecolor', 'blue');
p.addParameter('facecolor2', 'red');
p.addParameter('facealpha', 1);
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('nx', 1000);
p.addParameter('ny', 1000);
p.parse(varargin{:});
parameters = p.Results;
end