function out = E2_signature(f, varargin)
derivative_order = 2;
group = 'E2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, ~, fyy] = derivs{:}; % fxy not needed
        I0 = f;
        I1 = fx.*fx + fy.*fy;
        I2 = fxx + fyy;
        sig = {I0, I1, I2};
    end
end