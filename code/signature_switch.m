function out = signature_switch(f, sig_fun, order, group, varargin)
if isnumeric(f)
    switch numel(varargin)
        case 0
            hx = 1;
            hy = 1;
        case 1
            hx = varargin{1};
            hy = varargin{1};
        case 2
            hx = varargin{1};
            hy = varargin{2};
        otherwise
            error('incorrect input specification')
    end
    derivatives = compute_derivatives(f, order, hx, hy);
    out = sig_fun(derivatives); 
else
    out = Signature(f, sig_fun, order, group, varargin{:});
end