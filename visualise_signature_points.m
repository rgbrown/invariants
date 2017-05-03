function visualise_signature_points(I, S0, S1, S2)

% Richard Brown, 2015

% Create the figure
hF = figure( ...
       'Name',        'Signature Visualisation'...
       );

hA_im = subplot(1,2,1);
imshow(I)
axis('image')
colormap('hot')
hold on

hA_surf = subplot(1,2,2);
surf(S0, S1, S2, 'edgecolor', 'none', 'facealpha', 0.5);
colormap('hot')
hold on


% Initialise points and lines
[m, n] = size(I);
markerSize = 40;
axesLimits = [0.5, n+0.5, 0.5, m+0.5];

hold on
hx = plot(hA_im, 1, 1, 'b.', 'markersize', markerSize);
set(hA_im, 'xlim', axesLimits(1:2), 'ylim', axesLimits(3:4))
hs = plot3(hA_surf, 0, 0, 0, 'b.', 'markersize', markerSize);

% Set Axes Properties
grid on
%set(hA_surf, 'DataAspectRatio', [1 1 1])

% Associate the callback with mouse click
set(hF, 'WindowButtonMotionFcn', @foo)

% Callback nested function
    function foo(varargin)
        % Get the x point from the axes
        cp = get(hA_im, 'CurrentPoint');
        if cp(1,1) < axesLimits(1) || cp(1,1) > axesLimits(2) || ...
                cp(1,2) < axesLimits(3) || cp(1,2) > axesLimits(4)
            return
        end
        x = round(cp(1, 1:2));
        
        % Transform it

        
        % Modify the points and lines
        set(hx, 'XData', x(1), 'YData', x(2));
        set(hs, 'XData', S0(x(2), x(1)), ...
            'YData', S1(x(2), x(1)), ...
            'ZData', S2(x(2), x(1)));
    end % foo

end % EIGENDEMO
