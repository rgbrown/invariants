function out = T2_signature(f, varargin)
derivative_order = 1;
group = 'T2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy] = derivs{:};
        I0 = f;
        I1 = fx;
        I2 = fy;
        sig = {I0, I1, I2};
    end
end