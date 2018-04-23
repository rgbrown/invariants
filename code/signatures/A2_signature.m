function out = A2_signature(f, varargin)
derivative_order = 3;
group = 'A2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy] = derivs{:};
        C = fxx.*fyy - fxy.^2;
        D = fy.^2.*fxx - 2*fx.*fy.*fxy + fx.^2.*fyy;
        E = fxxx.*fy.^3 - 3*fxxy.*fx.*fy.^2 + 3*fxyy.*fx.^2.*fy - fyyy.*fx.^3;
        
        denom = sqrt(C.^6 + D.^6 + E.^4);
        sig = {f.*C.^3./denom, f.*D.^3./denom, f.*E.^2./denom};
    end
end