classdef MobiusTransform < SpatialTransform2D
    properties
        a
        b
        c
        d
        alpha
        gamma
    end
    methods
        function obj = MobiusTransform(a, b, c, d) 
            obj.a = a;
            obj.b = b;
            obj.c = c;
            obj.d = d;
            obj.alpha = a + 1i*b;
            obj.gamma = c + 1i*d;
        end
        
        function [xnew, ynew] = forward_coords(obj, x, y)
            z = x + 1i*y;
            phi = obj.alpha*z ./ (obj.gamma*z + 1);
            xnew = real(phi);
            ynew = imag(phi);
        end
        
        function [xnew, ynew] = reverse_coords(obj, x, y)
            z = x + 1i*y;
            w = -z ./(obj.gamma*z - obj.alpha);
            xnew = real(w);
            ynew = imag(w);
        end
    end
        
end