function varargout = PSL3R_signature(f, varargin)
[~, Fx, Fy, Fxx, Fxy, Fyy, Fxxx, Fxxy, Fxyy, Fyyy] = ...
    compute_derivatives(f, 3, varargin{:});
D = Fy.^2.*Fxx - 2*Fx.*Fy.*Fxy + Fx.^2.*Fyy;
E = Fxxx.*Fy.^3 - 3*Fxxy.*Fx.*Fy.^2 + 3*Fxyy.*Fx.^2.*Fy - Fyyy.*Fx.^3;

