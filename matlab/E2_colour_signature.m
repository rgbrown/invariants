function out = E2_signature_colour(F1, F2, varargin)
[~, F1x, F1y] = compute_derivatives(F1, 1, varargin{:});
[~, F2x, F2y] = compute_derivatives(F2, 1, varargin{:});

I0 = F1 + F2;
I1 = F1x.*F1x + F1y.*F1y + F2x.*F2x + F2y.*F2y;
I2 = F1x.*F2x + F1y.*F2y;
out = {I0, I1, I2};

end