function out = PSL3R_signature(f, varargin)
derivative_order = 3;
group = 'PSL3R';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy] = derivs{:};
        
        C = fxx.*fyy - fxy.^2;
        
        D = fy.^2.*fxx - 2*fx.*fy.*fxy + fx.^2.*fyy;
        
        E = fxxx.*fy.^3 - 3*fxxy.*fx.*fy.^2 + 3*fxyy.*fx.^2.*fy - fyyy.*fx.^3;
        
        Q4 = 4*fx.*fxy.^2.*fxyy - fx.^2.*fxyy.^2 - 2*fyyy.*fx.*fxy.*fxx + ...
            2*fyy.*fx.*fxyy.*fxx - 6*fy.*fxy.*fxyy.*fxx + ...
            2*fy.*fyyy.*fxx.^2 + fyyy.*fx.^2.*fxxy - 6*fyy.*fx.*fxy.*fxxy + ...
            4*fy.*fxy.^2.*fxxy + fy.*fx.*fxyy.*fxxy + 2*fy.*fyy.*fxx.*fxxy - ...
            fy.^2.*fxxy.^2 + 2*fyy.^2.*fx.*fxxx - fy.*fyyy.*fx.*fxxx ...
            -2*fy.*fyy.*fxy.*fxxx + fy.^2.*fxyy.*fxxx;
        
        P5 = fyyy.*fx.^3.*fxy - fyy.*fx.^2.*fxy.^2 + 2*fy.*fx.*fxy.^3 - ...
            fyy.*fx.^3.*fxyy - fy.*fx.^2.*fxy.*fxyy + fyy.^2.*fx.^2.*fxx - ...
            fy.*fyyy.*fx.^2.*fxx - 2*fy.*fyy.*fx.*fxy.*fxx - ...
            fy.^2.*fxy.^2.*fxx + 2*fy.^2.*fx.*fxyy.*fxx + fy.^2.*fyy.*fxx.^2 + ...
            2*fy.*fyy.*fx.^2.*fxxy - fy.^2.*fx.*fxy.*fxxy - fy.^3.*fxx.*fxxy - ...
            fy.^2.*fyy.*fx.*fxxx + fy.^3.*fxy.*fxxx;
        
        P4 = -4*C.^2 + Q4;
        
        denom = sqrt(D.^12 + P4.^6 + (E.^2 - 12*D.*P5).^4);
        sig = {f.*D.^6./denom, f.*P4.^3./denom, f.*(E.^2 - 12*D.*P5).^2./denom};
    end
end

