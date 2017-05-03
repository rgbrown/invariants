function f_forward = random_mobius()
coeffs = randn(1, 4) + 1i * randn(1, 4);
a = coeffs(1); b = 0.1*coeffs(2); c = coeffs(3); d = coeffs(4);
f_forward = @forward;

    function [Xn, Yn] = forward(X, Y)
        Z = X + 1i * Y;
        Zn = (a*Z + b) ./ (c*Z + d);
        Xn = real(Zn);
        Yn = imag(Zn);
    end

end