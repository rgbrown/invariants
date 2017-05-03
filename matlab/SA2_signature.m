function [sig3, sig4] = SA2_signature(f, varargin)
[~, Fx, Fy, Fxx, Fxy, Fyy, Fxxx, Fxxy, Fxyy, Fyyy] = ...
    compute_derivatives(f, 3, varargin{:});
C = Fxx.*Fyy - Fxy.^2;
D = Fy.^2.*Fxx - 2*Fx.*Fy.*Fxy + Fx.^2.*Fyy;
F = Fyy.*Fxxy.^2 + Fxx.*Fxyy.^2 + Fxyy.*Fxxx.*Fyyy - Fyy.*Fxxx.*Fxyy - ...
    Fxyy.*Fxxy.*Fxyy - Fxx.*Fxxy.*Fyyy;
sig3 = {f, C, D};
sig4 = {f, C, D, F};
end