function visualise_signatures(fn, sig_fn, varargin)
% Create a simple GUI to visualise the signature surfaces of two different
% images related by a transformation


% Initialise the GUI
handles.fig = figure();
if (nargin == 2)
    handles.image_axes_1 = subplot(1, 2, 1);
    handles.image_axes_2 = 0;
    handles.signature_axes = subplot(1, 2, 2);
else
    handles.image_axes_1 = subplot(2, 2, 1);
    handles.image_axes_2 = subplot(2, 2, 3);
    handles.signature_axes = subplot(2, 2, [2, 4]);
    xlim2 = [-1, 1];
    ylim2 = [-1, 1];
    tform = varargin{1};
end
handles.zoom = zoom(handles.fig);
handles.pan = pan(handles.fig);

xlim1 = [-1, 1];
ylim1 = [-1, 1];

npts = 300;
ncolors = 65536;
colormap(parula(ncolors));

clip = 3;

x1 = linspace(xlim1(1), xlim1(2), npts);
y1 = linspace(ylim1(1), ylim1(2), npts);
[X, Y] = meshgrid(x1, y1);
F1 = fn(X, Y);
handles.image_1 = image(x1, y1, ncolors*F1, 'parent', handles.image_axes_1);
set(handles.image_axes_1, 'DataAspectRatio', [1 1 1])

if nargin == 3
    x2 = linspace(xlim2(1), xlim2(2), npts);
    y2 = linspace(ylim2(1), ylim2(2), npts);
    [X, Y] = meshgrid(x2, y2);
    [X, Y] = tform.reverse(X, Y);
    F2 = fn(X, Y);
    handles.image_2 = image(x1, y1, ncolors*F2, 'parent', handles.image_axes_2);
    set(handles.image_axes_2, 'DataAspectRatio', [1 1 1])
    hx2 = diff(xlim2) / npts;
    hy2 = diff(ylim2) / npts;
    [S2z, S2x, S2y] = sig_fn(F2, hx2, hy2);
end
% Initialise the signature plots
hx1 = diff(xlim1) / npts;
hy1 = diff(ylim1) / npts;
[S1z, S1x, S1y] = sig_fn(F1, hx1, hy1);


handles.surf_1 = surf(S1x((1+clip):(end-clip), (1+clip):(end-clip)), ...
    S1y((1+clip):(end-clip), (1+clip):(end-clip)), ...
    S1z((1+clip):(end-clip), (1+clip):(end-clip)), ...
    'facecolor', 'blue', 'edgecolor', 'none', ...
    'facealpha', 0.5, 'parent', handles.signature_axes);

if nargin == 3
    hold on
    handles.surf_2 = surf(S2x((1+clip):(end-clip), (1+clip):(end-clip)), ...
        S2y((1+clip):(end-clip), (1+clip):(end-clip)), ...
        S2z((1+clip):(end-clip), (1+clip):(end-clip)), ...
        'facecolor', 'red', 'edgecolor', 'none', ...
        'facealpha', 0.5, 'parent', handles.signature_axes);
end
handles.zoom.ActionPostCallback = @motion_callback;
handles.pan.ActionPostCallback = @motion_callback;


function motion_callback(obj, event_obj)
        hax = event_obj.Axes;
        if hax == handles.signature_axes
            return
        end
        
        % process zoomed image
        xlim = get(hax, 'xlim');
        ylim = get(hax, 'ylim');
        x = linspace(xlim(1), xlim(2), npts);
        y = linspace(ylim(1), ylim(2), npts);
        [X, Y] = meshgrid(x, y);
        if hax == handles.image_axes_2
            [X, Y] = tform.reverse(X, Y);
            hs = handles.surf_2;
            him = handles.image_2;
        else
            hs = handles.surf_1;
            him = handles.image_1;
        end
        
        F = fn(X, Y);
        
        set(him, 'xdata', x, 'ydata', y, 'CData', ncolors*F);
        
        % process signature
        hx = diff(xlim) / npts;
        hy = diff(ylim) / npts;
        [Sz, Sx, Sy] = sig_fn(F, hx, hy);
       
        set(hs, 'XData', Sx((1+clip):(end-clip), (1+clip):(end-clip)), ...
            'YData', Sy((1+clip):(end-clip), (1+clip):(end-clip)), ...
            'ZData', Sz((1+clip):(end-clip), (1+clip):(end-clip)))
    end








end