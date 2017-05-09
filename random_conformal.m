function f_forward = random_conformal()
% Generate the first 10 Taylor coefficients
order = 100;
a = (randn(1, order+1) + 1i*randn(1, order+1)) ./ (factorial(0:order));
a(1) = a(1) / 10;
f_forward = @forward;
    function [Xn, Yn] = forward(X, Y)
       Z = X + 1i*Y;
       Zn = zeros(size(Z));
       for k = 0:order
           Zn = Zn + a(k+1)*Z.^k;
       end
       Xn = real(Zn);
       Yn = imag(Zn);
        
    end
end
