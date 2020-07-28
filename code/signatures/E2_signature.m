function out = E2_signature(f, varargin)
derivative_order = 2;
group = 'E2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy] = derivs{:}; % fxy not needed
        I0 = f;
        I1 = fx.*fx + fy.*fy;
        I2 = fxx + fyy;
        I3 = fx.^2.*fxx +2*fx.*fy.*fxy + fy.^2.*fyy; % SE2
        I4 = fy.^2.*fxx -2*fx.*fy.*fxy + fx.^2.*fyy; % SE2
        I5 = (-fx.*fy.*(fxx - fyy) + (fx.^2 - fy.^2).*fxy); %SE2
        I6 = fxx.^2 + fyy.^2 + 2*fxy.^2;
        sig = {I0, I1, I5};
       
    end
end