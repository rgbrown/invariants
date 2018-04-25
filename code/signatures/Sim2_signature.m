function out = Sim2_signature(f, varargin)
derivative_order = 2;
group = 'Sim2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy] = derivs{:};
        I1 = fx.^2 + fy.^2;
        I2 = (fxx + fxy).^2;
        I3 = fxx.^2 + 2*fxy.*fxy + fyy.^2;        
        denom = sqrt(I1.^2 + I2.^2 + I3.^2);
        sig = {f.*I1./denom, f.*I2./denom, f.*I3./denom};
    end
end