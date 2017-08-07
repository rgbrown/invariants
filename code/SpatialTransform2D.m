% SPATIALTRANSFORM2D
% Abstract class for working with 2D spatial transformations. To implement
% the class, the methods forward_coords and reverse_coords must be
% provided.

classdef (Abstract) SpatialTransform2D
    methods (Abstract)
        forward_coords(obj, x, y)
        reverse_coords(obj, x, y)
    end
    methods
        function varargout = forward(obj, varargin)
            if nargin == 3
                [Xp, Yp] = obj.forward_coords(varargin{:});
                varargout = {Xp, Yp};
            elseif nargin == 2 % function handle
                fp = obj.forward_fun(varargin{:});
                varargout = {fp};
            elseif nargin == 4 % image with x y limits
                Fp = obj.forward_image(varargin{:});
                varargout = {Fp};
            end
        end
        function varargout = reverse(obj, varargin)
            if nargin == 3
                [Xp, Yp] = obj.reverse_coords(varargin{:});
                varargout = {Xp, Yp};
            elseif nargin == 2 % function handle
                fp = obj.reverse_fun(varargin{:});
                varargout = {fp};
            elseif nargin == 4 % image with x y limits
                Fp = obj.reverse_image(varargin{:});
                varargout = {Fp};
            end
        end
                
        function Fp = forward_image(obj, F, x, y)
            nx = size(F, 2);
            ny = size(F, 1);
            x = check_xlim(x, nx);
            y = check_xlim(y, ny);
            [X, Y] = meshgrid(x, y);
            [X_irreg, Y_irreg] = obj.reverse(X, Y);
            Fp = interp2(X, Y, F, X_irreg, Y_irreg, 'cubic');
        end
        function Fp = reverse_image(obj, F, x, y)
            nx = size(F, 2);
            ny = size(F, 1);
            x = check_xlim(x, nx);
            y = check_xlim(y, ny);
            [X, Y] = meshgrid(x, y);
            [X_irreg, Y_irreg] = obj.forward(X, Y);
            Fp = interp2(X, Y, F, X_irreg, Y_irreg, 'cubic');
        end
        function fp = forward_fun(obj, f)
            fp = @out_fun;
            function z = out_fun(x, y)
                [xp, yp] = obj.reverse(x, y);
                z = f(xp, yp);
            end
        end
        function fp = reverse_fun(obj, f)
            fp = @out_fun;
            function z = out_fun(x, y)
                [xp, yp] = obj.forward(x, y);
                z = f(xp, yp);
            end
        end
        
    end
end

function x = check_xlim(x, nx)
if numel(x) == 2
    x = linspace(x(1), x(2), nx);
elseif numel(x) ~= nx
    error('x must be of the form [xmin, xmax], or a vector nx long');
end

end