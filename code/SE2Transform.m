classdef SE2Transform < SpatialTransform2D
    properties
        theta
        tx % translation vector
        ty %
        c % sine theta
        s % cos theta
    end
    methods
        function obj = SE2Transform(theta, tx, ty) 
            obj.theta = theta;
            obj.tx = tx;
            obj.ty = ty;
            obj.c = cos(theta);
            obj.s = sin(theta);
        end
        
        function [xnew, ynew] = forward_coords(obj, x, y)
            xnew = obj.c*x - obj.s*y + obj.tx;
            ynew = obj.s*x + obj.c*y + obj.ty;
        end
        
        function [xnew, ynew] = reverse_coords(obj, x, y)
            xnew = obj.c*(x - obj.tx) + obj.s*(y - obj.ty);
            ynew = -obj.s*(x - obj.tx) + obj.c*(y - obj.ty);
        end
    end
        
end