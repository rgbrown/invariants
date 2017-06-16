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
            syms x y
            assert(isa(fn, 'sym') || isa(fn, 'symfun'));
            obj.derivative_order = order;
            obj.signature_fn = sig_fn;
            obj.fn = fn;
            obj.derivatives = compute_derivatives(fn, order);  
            obj.derivatives_matlab = cellfun(@(f) ...
                matlabFunction(f, 'Vars', [x y]), ...
                obj.derivatives, 'UniformOutput', false);
        end
        
        function sig = evaluate(obj, x, y)
            if isnumeric(x) && isnumeric(y)
                d_numeric = cellfun(@(f) f(x, y), ...
                    obj.derivatives_matlab, 'UniformOutput', false);
                sig = obj.signature_fn(d_numeric);
            else
                sig = obj.signature(obj.derivatives);
            end
            
        end
        
        function draw(obj, varargin)
            params = draw_parameters(varargin{:});
            [X, Y] = regular_grid(params.xlim(1), params.xlim(2), params.nx, ...
                params.ylim(1), params.ylim(2), params.ny);
            sig = obj.evaluate(X, Y);
            surf(sig{2}, sig{3}, sig{1}, 'facecolor', params.facecolor, ...
            'edgecolor', 'none', ...
            'facealpha', params.facealpha)
            camlight()
        end
    end
end

function params = draw_parameters(varargin)
p = inputParser();
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('nx', 1000);
p.addParameter('ny', 1000);
p.addParameter('facecolor', 'blue')
p.addParameter('facealpha', 1);
p.parse(varargin{:})
params = p.Results;
end
