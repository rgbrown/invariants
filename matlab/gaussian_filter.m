function K = gaussian_filter(sigma, nk)
%GAUSSIAN_FILTER
%    K = gaussian_filter(sigma, nk)
% Note, units are in pixels
if sigma > nk/2
    error('idiot')
end
[Xk, Yk] = meshgrid(linspace(-nk/2, nk/2, nk), linspace(-nk/2, nk/2, nk));
K = exp(-(Xk.^2 + Yk.^2) / (2*sigma^2));
K = K / sum(K(:));
end