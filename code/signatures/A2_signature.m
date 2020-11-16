function out = A2_signature(f, varargin)
derivative_order = 3;
group = 'A2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy] = derivs{:};
        C = fx.^2.*fyy + fxx.*fy.^2 - 2*fx.*fxy.*fy; % weight 2
        D = fxx.*fyy - fxy.^2; % weight 2
        E = fx.^3.*fyyy - fxxx.*fy.^3 + 3*fx.*fxxy.*fy.^2 - 3*fx.^2.*fxyy.*fy; % weight 4
        denom = sqrt(C.^4 + D.^4 + E.^2);
        sig = {f.*C.^2./denom, f.*D.^2./denom, f.*E./denom};
    end
end