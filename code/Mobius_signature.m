function out = Mobius_signature(f, varargin)
derivative_order = 3;
out = signature_switch(f, @evaluate, derivative_order, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy] = derivs{:};
        
        J1 = fx.*fx + fy.*fy;
        
        J2 = fxx + fyy;
        
        J3 = J1.*(fx.*(fxxx + fxyy) + fy.*(fxxy + fyyy)) + ...
            2*J2.*(fx.^2.*fxx + 2*fx.*fy.*fxy + fy.^2.*fyy);
        
        J4 = J1.*(fx.*(fxxy + fyyy) - fy.*(fxxx + fxyy)) + ...
            2*J2.*(fx.^2.*fxy + fx.*fy.*fyy - fx.*fy.*fxx - fy.^2.*fxy);
        
        K1 = fy.^5.*fyyy + 9/2*fy.^2.*fyy.^2.*fx.^2 + fy.^3.*fyyy.*fx.^2 + ...
            3/2*fyy.^2.*fx.^4 -9*fy.^3.*fyy.*fx.*fxy + 3.*fy.*fyy.*fx.^3.*fxy + ...
            3/2*fy.^4.*fxy.^2 - 9*fy.^2.*fx.^2.*fxy.^2 + ...
            3/2*fx.^4.*fxy.^2 + 3*fy.^4.*fx.*fxyy + 3*fy.^2.*fx.^3.*fxyy + ...
            3*fy.^4.*fyy.*fxx + 3*fyy.*fx.^4.*fxx + 3*fy.^3.*fx.*fxy.*fxx -...
            9*fy.*fx.^3.*fxy.*fxx + 3/2*fy.^4.*fxx.^2 + 9/2*fy.^2.*fx.^2.*fxx.^2 + ...
            3*fy.^3.*fx.^2.*fxxy + 3*fy.*fx.^4.*fxxy + fy.^2.*fx.^3.*fxxx + ...
            fx.^5.*fxxx;
        
        K4 = -3*fy.*fyy.^2.*fx.^3 + fy.^2.*fyyy.*fx.^3 + fyyy.*fx.^5 + 9*fy.^2.*fyy.*fx.^2.*fxy ...
            - 3*fyy.*fx.^4.*fxy - 6*fy.^3.*fx.*fxy.^2 + 6*fy.*fx.^3.*fxy.^2 - ...
            3*fy.^3.*fx.^2.*fxyy - 3*fy.*fx.^4.*fxyy - 3*fy.^3.*fyy.*fx.*fxx + ...
            3*fy.*fyy.*fx.^3.*fxx + 3*fy.^4.*fxy.*fxx - 9*fy.^2.*fx.^2.*fxy.*fxx + 3*fy.^3.*fx.*fxx.^2 + ...
            3*fy.^4.*fx.*fxxy + 3*fy.^2.*fx.^3.*fxxy - fy.^5.*fxxx - fy.^3.*fx.^2.*fxxx;
        
        % Choices: J1.^4, J2^4, J1*J3, K1, K4, J1*J4
        I1 = J1.^4;
        I2 = K1; %J2.^4;
        I3 = K4; %J1.*J3;
        
        denom = sqrt(I1.^2 + I2.^2 + I3.^2);
        sig = {f.*I1./denom, f.*I2./denom, f.*I3./denom};
        %denom = sqrt(J1.^2 + J2.^2);
        %sig = {f, J1./denom, J2./denom};
            
        
        
    end
end
