classdef Signature < handle
    properties
        fn
        fn_numeric
        group
        signature_fn
        derivative_order
        derivatives
        derivatives_matlab
        camera_info
    end
    methods
        function obj = Signature(fn, sig_fn, order, group, varargin)
            syms x y
            assert(isa(fn, 'sym') || isa(fn, 'symfun'));
            obj.derivative_order = order;
            obj.signature_fn = sig_fn;
            obj.fn = fn;
            obj.fn_numeric = matlabFunction(fn, 'Vars', [x y]);
            obj.derivatives = compute_derivatives(fn, order);  
            obj.derivatives_matlab = cellfun(@(f) ...
                matlabFunction(f, 'Vars', [x y]), ...
                obj.derivatives, 'UniformOutput', false);
            obj.group = group;
        end
        
        function varargout = evaluate(obj, x, y)
            if isnumeric(x) && isnumeric(y)
                d_numeric = cellfun(@(f) f(x, y), ...
                    obj.derivatives_matlab, 'UniformOutput', false);
                sig = obj.signature_fn(d_numeric);
            else
                derivs = cell(numel(obj.derivatives), 1);
                for i = 1:numel(obj.derivatives)
                    derivs{i} = obj.derivatives{i}(x, y);
                end
                sig = obj.signature_fn(derivs);
            end
            varargout = sig;
        end
        
        function draw(obj, varargin)
            params = draw_parameters(varargin{:});
            [X, Y] = regular_grid(params.xlim(1), params.xlim(2), params.nx, ...
                params.ylim(1), params.ylim(2), params.ny);
            [I0, I1, I2] = obj.evaluate(X, Y);
            surf(I0, I1, I2, 'facecolor', params.facecolor, ...
            'edgecolor', 'none', ...
            'facealpha', params.facealpha)
            if isempty(obj.camera_info)
                camlight()
            else
                obj.camera_info.apply()
            end
            cameratoolbar();
            set(gca, 'fontsize', 16, 'TickLabelInterpreter', 'latex')
            xlabel('$I_1$', 'interpreter', 'latex')
            ylabel('$I_2$', 'interpreter', 'latex')
            zlabel('$I_3$', 'interpreter', 'latex')
            
            if params.showscanlines
                hold on
                xscan = linspace(params.xlim(1), params.xlim(2), params.nlines);
                yscan = linspace(params.ylim(1), params.ylim(2), params.nlines);

                t = linspace(0, 1, params.nscan);
                Xscan = zeros(params.nscan, 2*params.nlines);
                Yscan = zeros(size(Xscan));
                for i = 1:params.nlines
                    Xscan(:, i) = ...
                        t*params.xlim(1) + (1 - t)*params.xlim(2);
                    Yscan(:, i) = yscan(i);
                end
                for i = 1:params.nlines
                    Xscan(:, i + params.nlines) = xscan(i);
                    Yscan(:, i + params.nlines) = ...
                        t*params.ylim(1) + (1 - t)*params.ylim(2);
                end 
                [X0, X1, X2] = obj.evaluate(Xscan, Yscan);
                plot3(X0, X1, X2, params.scanparams{:})
            end
        end
        
        function draw_image(obj, varargin)
            params = draw_parameters(varargin{:});
            x = linspace(params.xlim(1), params.xlim(2), params.nx_image);
            y = linspace(params.ylim(1), params.ylim(2), params.ny_image);
            [X, Y] = meshgrid(x, y);
            imagesc(x, y, obj.fn_numeric(X, Y), params.clim);
            axis image
            colormap(params.cmap);
            if params.showscanlines
                hold on
                xscan = linspace(params.xlim(1), params.xlim(2), params.nlines);
                yscan = linspace(params.ylim(1), params.ylim(2), params.nlines);

                t = linspace(0, 1, params.nscan);
                Xscan = zeros(params.nscan, 2*params.nlines);
                Yscan = zeros(size(Xscan));
                for i = 1:params.nlines
                    Xscan(:, i) = ...
                        t*params.xlim(1) + (1 - t)*params.xlim(2);
                    Yscan(:, i) = yscan(i);
                end
                for i = 1:params.nlines
                    Xscan(:, i + params.nlines) = xscan(i);
                    Yscan(:, i + params.nlines) = ...
                        t*params.ylim(1) + (1 - t)*params.ylim(2);
                end 
                plot(Xscan, Yscan, params.scanparams{:})
            end
        end
        
        function save_camera(obj, varargin)
            if nargin == 2
                savetofile = true;
                fname = varargin{1};
            else
                savetofile = false;
            end
            obj.camera_info = CameraInfo();
            obj.camera_info.loadFromAxes();
        end
    end
end

function params = draw_parameters(varargin)
p = inputParser();
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('nx', 1000);
p.addParameter('ny', 1000);
p.addParameter('nx_image', 2000);
p.addParameter('ny_image', 2000);
p.addParameter('facecolor', 'blue')
p.addParameter('facealpha', 1);
p.addParameter('clim', [0 1]);
p.addParameter('cmap', gray(65536));
p.addParameter('showscanlines', true);
p.addParameter('scanparams', {'y', 'linewidth', 2});
% Set up scan lines
p.addParameter('nlines', 21);
p.addParameter('nscan', 1000);
p.parse(varargin{:})
params = p.Results;
end
