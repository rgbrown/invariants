function varargout = compute_derivatives(F, N, h)
% COMPUTE_DERIVATIVES compute derivatives up to order N, returned in order
%     fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy, etc
derivs = cell((N+1)*(N+2)/2, 1);
derivs{1} = F;
k = 2; % index where next derivative goes
for i = 1:N % order
    start = ((i - 1)*i)/2;
    for j = 1:i
        if j == 1
            [derivs{k}, derivs{k+1}] = gradient(derivs{start+j}, h);
            k = k + 1;
        else
            [~, derivs{k}] = gradient(derivs{start+j}, h);
        end
        k = k + 1;
    end
end

end