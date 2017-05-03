function sig = A2_signature(F, varargin)
[~, Fx, Fy, Fxx, Fxy, Fyy] = compute_derivatives(F, 2, varargin{:});
I0 = F;
I1 = Fx.*Fx + Fy.*Fy;
v = {Fxx.*Fx + Fxy.*Fy, Fxy.*Fx + Fyy.*Fy};
I2 = Fx.*v{2} - Fy.*v{1};
sig = {I0, I1, I2};
end