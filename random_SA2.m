function [f_forward, A, b] = random_SA2()
theta = 2*pi*rand();
gamma = 0.5;
R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
A = gamma*R + rand(2);
if det(A) < 0
    A(1, :) = -A(1, :);
end
A = 1 / sqrt(det(A)) * A;
b = 0.2 * randn(2, 1);
f_forward = @forward_tform;

    function [Xn, Yn] = forward_tform(X, Y)
        z = A\([X(:), Y(:)]' - repmat(b, 1, numel(X)));
        Xn = reshape(z(1, :), size(X));
        Yn = reshape(z(2, :), size(Y));
    end
end




