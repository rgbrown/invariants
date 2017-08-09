classdef SA2Transform < SpatialTransform2D
    properties
        a
        b
        c
        d
        tx
        ty
        det
    end
    methods
        function obj = SA2Transform(a, b, c, d, tx, ty) 
            obj.a = a;
            obj.b = b;
            obj.c = c;
            obj.d = d;
            obj.det = obj.a*obj.d - obj.b*obj.c;
            obj.tx = tx;
            obj.ty = ty;
            assert(norm(obj.det) > 1e-12);
            assert(norm(obj.det - 1) < 1e-12);
        end
        
        function [xnew, ynew] = forward_coords(obj, x, y)
            xnew = obj.a*x + obj.b*y + obj.tx;
            ynew = obj.c*x + obj.d*y + obj.ty;
        end
        
        function [xnew, ynew] = reverse_coords(obj, x, y)
            xnew = 1/obj.det*(obj.d*(x - obj.tx) - obj.b*(y - obj.ty));
            ynew = 1/obj.det*(-obj.c*(x - obj.tx) + obj.a*(y - obj.ty));
        end
    end
        
end