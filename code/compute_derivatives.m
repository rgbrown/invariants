function derivs = compute_derivatives(F, N, varargin)
if isa(F, 'symfun') || isa(F, 'sym')
    derivs = compute_derivatives_symbolic(F, N, varargin{:});
else
    derivs = compute_derivatives_numeric(F, N, varargin{:});
end
derivs = derivs;
end

function derivs = compute_derivatives_symbolic(F, N, varargin)
syms x y
derivs = cell((N+1)*(N+2)/2, 1);
derivs{1} = F;
k = 2;
for i = 1:N % order
    start = ((i - 1)*i)/2;
    for j = 1:i
        if j == 1
            derivs{k} = simplify(diff(derivs{start + j}, x));
            derivs{k+1} = simplify(diff(derivs{start + j}, y));
            k = k + 1;
        else
            derivs{k} = simplify(diff(derivs{start + j}, y));
        end
        k = k + 1;
    end
end
end


function derivs = compute_derivatives_numeric(F, N, varargin)
% COMPUTE_DERIVATIVES compute derivatives up to order N, returned in order
%     fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy, etc
%
% put function signature description here
%
%
% Example:
%     [f, fx, fy, fxx, fxy, fyy] = compute_derivatives(F, 2, 0.01)

if nargin == 3
    hx = varargin{1};
    hy = hx;
else
    hx = varargin{1};
    hy = varargin{2};
end

derivs = cell((N+1)*(N+2)/2, 1);
derivs{1} = F;
k = 2; % index where next derivative goes
for i = 1:N % order
    start = ((i - 1)*i)/2;
    for j = 1:i
        if j == 1
            [derivs{k}, derivs{k+1}] = gradient(derivs{start+j}, hx, hy);
            k = k + 1;
        else
            [~, derivs{k}] = gradient(derivs{start+j}, hx, hy);
        end
        k = k + 1;
    end
end
end