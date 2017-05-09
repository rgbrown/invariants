function [sig3, sig4] = R2_signature(F, varargin)
[~, Fx, Fy, Fxx, Fxy, Fyy] = compute_derivatives(F, 2, varargin{:});
I0 = F;
I1 = Fx;
I2 = Fy;
I3 = Fxx;
sig3 = {I0, I1, I2};
sig4 = {I0, I1, I2, I3};
end