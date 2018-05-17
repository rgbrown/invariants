function group_experiment(f, tform, sigfun, varargin)
params = parse_inputs(varargin{:});

% Create signature objects for the function and transformed function
x = []; y = []; % to avoid stupid behaviour of syms
syms x y
[xp, yp] = tform.reverse(x, y);
fp = f(xp, yp);
sig = sigfun(f);
sigp = sigfun(fp);

% Numerical image and transformed image functions
f_map = matlabFunction(f);
fp_map = matlabFunction(fp);

xlim = params.xlim;
ylim = params.ylim;

fscan = ~isempty(params.scanlines);
visualise();
    function visualise()
        figure(1)
        clf
        sig.draw_image('showscanlines', fscan);
        figure(2)
        sigp.draw_image('showscanlines', false);
        draw_image(f_map, 'xlim', xlim, 'ylim', ylim);
        subplot(1,2,2)
        draw_image(fp_map, 'xlim', xlim, 'ylim', ylim);
        figure(2)
        clf
        sig.draw();
        figure(3)
        clf
        sig.draw('facealpha', 0.5);
        hold on
        sigp.draw('facecolor', 'red', 'facealpha', 0.5);
        draw_signature(@sigp.evaluate, 'xlim', xlim, 'ylim', ylim, ...
            'facecolor', 'red', 'facealpha', 0.5);  
        axis off
        if fscan
            [X, Y] = params.scanlines{:};
            figure(1)
            subplot(1,2,1)
            hold on
            plot(X, Y, 'y');
            [Xp, Yp] = tform.forward(X, Y);
            subplot(1,2,2)
            hold on
            plot(Xp, Yp, 'y')
            axis([params.xlim params.ylim]);
            [X0, X1, X2] = sig_map(X, Y);
            figure(2)
            hold on
            plot3(X0, X1, X2, params.scanparams{:});
        end
    end

end

function [I0, I1, I2] = create_sig_mapping(x, y, sig)
out = sig.evaluate(x, y);
I0 = out{1};
I1 = out{2};
I2 = out{3};
end

function parameters = parse_inputs(varargin)
p = inputParser();
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('scanlines', {});
p.addParameter('scanparams', {'y', 'linewidth', 2});
p.addParameter('tlim', [-1, 1]);
p.addParameter('nt', 1000);
p.parse(varargin{:})
parameters = p.Results;
end
