classdef PSL3RTransform < SpatialTransform2D
    properties
        a
        b
        c
        d
        g
        h
    end
    methods
        function obj = PSL3RTransform(a, b, c, d, g, h) 
            obj.a = a;
            obj.b = b;
            obj.c = c;
            obj.d = d;
            obj.g = g;
            obj.h = h;
        end
        
        function [xnew, ynew] = forward_coords(obj, x, y)
            denom = 1 + obj.g*x + obj.h*y;
            xnew = (obj.a*x + obj.b*y) ./ denom;
            ynew = (obj.c*x + obj.d*y) ./ denom;
        end
        
        function [xnew, ynew] = reverse_coords(obj, x, y)
            denom = (obj.c*obj.h - obj.d*obj.g) * x + ...
                (obj.b*obj.g - obj.a*obj.h) * y + ...
                obj.a*obj.d - obj.b*obj.c;
            
            xnew = (obj.d*x - obj.b*y) ./ denom;
            ynew = (-obj.c*x + obj.a*y) ./ denom;
        end
    end
        
end