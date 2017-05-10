classdef Signature
    properties
        fn
        signature_fn
        derivative_order
        derivatives
        derivatives_matlab
    end
    methods
        function obj = Signature(fn, sig_fn, order, varargin)
            assert(isa(fn, 'sym') || isa(fn, 'symfun'));
            obj.derivative_order = order;
            obj.signature_fn = sig_fn;
            obj.fn = fn;
            obj.derivatives = compute_derivatives(fn, order);  
            obj.derivatives_matlab = cellfun(@matlabFunction, ...
                obj.derivatives, 'UniformOutput', false);
        end
        
        function sig = evaluate(obj, x, y)
            if isnumeric(x) && isnumeric(y)
                d_numeric = cellfun(@(f) f(x, y), ...
                    obj.derivatives_matlab, 'UniformOutput', false);
                sig = obj.signature_fn(d_numeric);
            end
            
        end
    end
end
