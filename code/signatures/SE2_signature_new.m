function out = SE2_signature_new(f, varargin)
derivative_order = 2;
group = 'SE2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy] = derivs{:};
        I0 = f;
        I1 = fx.*fx + fy.*fy;
        I2 = fy.^2.*fxx - 2*fx.*fy.*fxy + fx.^2.*fyy;
        I3 = fx.*fy.*fxy;
        sig = {I0, I1, I2};
    end
end