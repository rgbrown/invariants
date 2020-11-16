classdef DiffconTransform < SpatialTransform2D
    properties
       c % Offset for function psi(z) = (z - c).^2 + c.^2
       a
       b
    end
    methods
        function obj = DiffconTransform(c) 
            obj.c = c;
            obj.a = 1.5/c^2;
            obj.b = -obj.a*c^2;
        end
        
        function [xnew, ynew] = forward_coords(obj, x, y)
            z = x + 1i*y;
            znew = -sqrt((z - obj.b)./obj.a) + obj.c;
            xnew = real(znew);
            ynew = imag(znew);   
            % Now do it the insane way
%             xnew = obj.a*((x - obj.c).^2 - y.^2) + obj.b;
%             ynew = obj.a*(-2*y.*(x - obj.c));
        end
        
        function [xnew, ynew] = reverse_coords(obj, x, y)
            z = x + 1i*y;
            znew = obj.a*(z - obj.c).^2 + obj.b;
            xnew = real(znew);
            ynew = imag(znew);
                     
%             r = -1/sqrt(obj.a)*((x - obj.b).^2 + y.^2).^(1/4);
%             theta = atan(y ./ (2*(x - obj.b)));
%             xnew = r.*cos(theta);
%             ynew = r.*sin(theta);
        end
    end
        
end