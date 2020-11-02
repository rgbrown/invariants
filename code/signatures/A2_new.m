function out = A2_new(f, varargin)
derivative_order = 3;
group = 'A2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy] = derivs{:};
        C = fx.^2.*fyy + fxx.*fy.^2 - 2*fx.*fxy.*fy;
        D = fxx.*fyy - fxy.^2;
        E = fx.^3.*fyyy - fxxx.*fy.^3 + 3*fx.*fxxy.*fy.^2 - 3*fx.^2.*fxyy.*fy;
        
        sig = {f, I1, I2};
    end
end