function out = Sim2_signature(f, varargin)
derivative_order = 2;
group = 'Sim2';
out = signature_switch(f, @evaluate, derivative_order, group, varargin{:});
    function sig = evaluate(derivs)
        [f, fx, fy, fxx, fxy, fyy] = derivs{:};
        J1 = fxx + fyy;     % Weight 2
        J2 = fx.^2 + fy.^2; % Weight 2
        J3 = fx.^2.*fxx + 2*fx.*fy.*fxy + fy.^2.*fyy; % Weight 4
        J4 = fxx.^2 + 2*fxy.^2 + fyy.^2; % Weight 4
        denom = sqrt(J1.^4 + J2.^4 + J4.^2);
        sig = {f.*J1.^2./denom, f.*J2.^2./denom, f.*J4./denom};
    end
end