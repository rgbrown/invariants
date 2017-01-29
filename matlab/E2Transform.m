classdef E2Transform < SpatialTransform2D
    properties
        determinant
        theta
        tx % translation vector
        ty %
        c % sine theta
        s % cos theta
    end
    methods
        function obj = E2Transform(theta, determinant, tx, ty) 
            obj.theta = theta;
            obj.determinant = sign(determinant);
            obj.tx = tx;
            obj.ty = ty;
            obj.c = cos(theta);
            obj.s = sin(theta);
        end
        
        function [xnew, ynew] = forward(obj, x, y)
            xnew = obj.determinant*(obj.c*x - obj.s*y) + obj.tx;
            ynew = obj.s*x + obj.c*y + obj.ty;
        end
        
        function [xnew, ynew] = reverse(obj, x, y)
            xnew = obj.determinant*obj.c*(x - obj.tx) + obj.s*(y - obj.ty);
            ynew = -obj.determinant*obj.s*(x - obj.tx) + obj.c*(y - obj.ty);
        end
    end
        
end