classdef (Abstract) SpatialTransform2D
    methods (Abstract)
        forward(obj, x, y)
        reverse(obj, x, y)
    end
    methods
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
        
    end
end

function x = check_xlim(x, nx)
if numel(x) == 2
    x = linspace(x(1), x(2), nx);
elseif numel(x) ~= nx
    error('x must be of the form [xmin, xmax], or a vector nx long');
end

end