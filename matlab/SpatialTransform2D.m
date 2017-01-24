classdef (Abstract) SpatialTransform2D
    methods (Abstract)
        forward(obj, x, y)
        reverse(obj, x, y)
    end
end