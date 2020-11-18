function out = SA2_signature(f, varargin)
derivative_order = 3;
group = 'SA2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy] = derivs{:};
        C = fxx.*fyy - fxy.^2;
        D = fy.^2.*fxx - 2*fx.*fy.*fxy + fx.^2.*fyy;
        E = fxxx.*fy.^3 - 3*fxxy.*fx.*fy.^2 + 3*fxyy.*fx.^2.*fy - fyyy.*fx.^3;
        F = 2*fxy.^2-fxx.^2-fyy.^2;
        I3 = fxxx.*fxyy.*fyy - fxxx.*fxy.*fyyy - fxxy.^2.*fyy + ...
            fxxy.*fxx.*fyyy + fxxy.*fxyy.*fxy - fxx.*fxyy.^2;
        %F = fyy.*fxxy.^2 + fxx.*fxyy.^2 + fxyy.*fxxx.*fyyy - fyy.*fxxx.*fxyy - ...
        %fxyy.*fxxy.*fxyy - fxx.*fxxy.*fyyy;
        %sig = {C, D, E};
        sig = {f, C, D};
    end
end