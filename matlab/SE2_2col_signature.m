function out = SE2_2col_signature(F, G, varargin)
[~, Fx, Fy] = compute_derivatives(F, 1, varargin{:});
[~, Gx, Gy] = compute_derivatives(G, 1, varargin{:});

I0 = F;
I1 = Fx.*Fx + Fy.*Fy;
I2 = Fx.*Gy - Fy.*Gx;
out = {I0, I1, I2};
end