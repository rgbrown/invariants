function sig = A2_signature(f, varargin)
[~, Fx, Fy, Fxx, Fxy, Fyy, Fxxx, Fxxy, Fxyy, Fyyy] = ...
    compute_derivatives(f, 3, varargin{:});
C = Fxx.*Fyy - Fxy.^2;
D = Fy.^2.*Fxx - 2*Fx.*Fy.*Fxy + Fx.^2.*Fyy;
E = Fxxx.*Fy.^3 - 3*Fxxy.*Fx.*Fy.^2 + 3*Fxyy.*Fx.^2.*Fy - Fyyy.*Fx.^3;

denom = sqrt(C.^6 + D.^6 + E.^4);
sig = {f.*C.^3./denom, f.*D.^3./denom, f.*E.^2./denom};
end