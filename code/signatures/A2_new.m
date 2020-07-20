function out = A2_new(f, varargin)
derivative_order = 3;
group = 'A2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy] = derivs{:};
        
        I4_1 = fxx.*fyy-fxy.^2;
        I4_2 = fx.^2.*fyy - 2*fx.*fy.*fxy + fy.^2.*fxx;
        I6_1 = (fxx.*fxyy - 2*fxy.*fxxy + fyy.*fxxx).*fy - ...
            (fxx.*fyyy - 2*fxy.*fxyy + fyy.*fxxy).*fx;
        I6_2 = -fx.^3.*fyyy + 3*fx.^2.*fy.*fxyy - 3*fx.*fy.^2.*fxxy + ...
            fy.^3.*fxxx;
        
        sig = {f, I4_2./I4_1, I6_2./I6_1};
    end
end