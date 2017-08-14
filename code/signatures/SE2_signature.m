function out = SE2_signature(f, varargin)
derivative_order = 2;
out = signature_switch(f, @evaluate, derivative_order, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy] = derivs{:};
        I0 = f;
        I1 = fx.*fx + fy.*fy;
        v = {fxx.*fx + fxy.*fy, fxy.*fx + fyy.*fy};
        I2 = fx.*v{2} - fy.*v{1};
        sig = {I0, I1, I2};
    end
end