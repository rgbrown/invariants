function SE2_experiment(f)
n = 400;
xlim = [-1 1];
ylim = [-1 1];
x = linspace(xlim(1), xlim(2), n);
y = linspace(xlim(1), xlim(2), n);
[X, Y] = meshgrid(x, y);
f1 = figure();

% initialise image part of the gui
h_image_axes = subplot(1,2,1);
ncolors = 65536;
colormap(bone(ncolors));
F = f(X, Y);
him = image(x, y, ncolors*F, 'parent', h_image_axes);

% initialise signature part of the GUI
h_signature_axes = subplot(1,2,2);
hx = (xlim(2) - xlim(1)) / n;
hy = (ylim(2) - ylim(1)) / n;
[S0, S1, S2] = SE2_signature(F, hx, hy);
hs = surf(S1(2:end-1, 2:end-1), S2(2:end-1, 2:end-1), S0(2:end-1, 2:end-1),...
    'edgecolor', 'none');
camlight
shading interp



% set up callbacks
hz = zoom(f1);
hp = pan(f1);
hz.ActionPostCallback = @motion_callback;
hp.ActionPostCallback = @motion_callback;


    function motion_callback(obj, event_obj)
        hax = event_obj.Axes;
        if hax ~= h_image_axes
            return
        end
        
        % process zoomed image
        xlim = get(hax, 'xlim');
        ylim = get(hax, 'ylim');
        x = linspace(xlim(1), xlim(2), n);
        y = linspace(ylim(1), ylim(2), n);
        [X, Y] = meshgrid(x, y);
        F = f(X, Y);
        set(him, 'xdata', x, 'ydata', y, 'CData', ncolors*F);
        
        % process signature
        hx = (xlim(2) - xlim(1)) / n;
        hy = (ylim(2) - ylim(1)) / n;
        [S0, S1, S2] = SE2_signature(F, hx, hy);
        set(hs, 'XData', S1(2:end-1, 2:end-1), 'YData', ...
            S2(2:end-1, 2:end-1), ...
            'ZData', S0(2:end-1, 2:end-1))
    end



end