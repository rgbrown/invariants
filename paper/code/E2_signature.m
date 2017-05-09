function sig = E2_signature(F, varargin)
[~, Fx, Fy, Fxx, ~, Fyy] = compute_derivatives(F, 2, varargin{:});
I0 = F;
I1 = Fx.*Fx + Fy.*Fy;
I2 = Fxx + Fyy;
sig = {I0, I1, I2};
end