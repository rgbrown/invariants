classdef Sim2Transform < SpatialTransform2D
    properties
        theta
        determinant
        tx % translation vector
        ty %
        lambda
        c % sine theta
        s % cos theta
    end
    methods
        function obj = Sim2Transform(theta, determinant, tx, ty, lambda) 
            obj.theta = theta;
            obj.determinant = determinant;
            obj.tx = tx;
            obj.ty = ty;
            obj.lambda = lambda;
            obj.c = cos(theta);
            obj.s = sin(theta);
        end
        
        function [xnew, ynew] = forward_coords(obj, x, y)
            xnew = obj.lambda*obj.determinant*(obj.c*x - obj.s*y) + obj.tx;
            ynew = obj.lambda*(obj.s*x + obj.c*y) + obj.ty;
        end
        
        function [xnew, ynew] = reverse_coords(obj, x, y)
            xnew = 1/obj.lambda*(obj.c*obj.determinant*(x - obj.tx) + obj.s*(y - obj.ty));
            ynew = 1/obj.lambda*(-obj.s*obj.determinant*(x - obj.tx) + obj.c*(y - obj.ty));
        end
    end
        
end