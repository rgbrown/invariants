classdef T2Transform < SpatialTransform2D
    properties
        tx % translation vector
        ty %
    end
    methods
        function obj = T2Transform(tx, ty) 
            obj.tx = tx;
            obj.ty = ty;
        end
        
        function [xnew, ynew] = forward_coords(obj, x, y)
            xnew = x + obj.tx;
            ynew = y + obj.ty;
        end
        
        function [xnew, ynew] = reverse_coords(obj, x, y)
            xnew = x - obj.tx;
            ynew = y - obj.ty;
        end
    end
        
end