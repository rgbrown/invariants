%% Signature surface generation script
syms x y
f(x, y) = exp(-2*x.^2 - 4.*sin(y + x).^2);
f_numeric = matlabFunction(f);

xlim = [-1, 1];
ylim = [-1, 1];
ngrid = 1000;
[X, Y, xvec, yvec] = regular_grid(xlim(1), xlim(2), ngrid, ...
    ylim(1), ylim(2), ngrid);

%% E(2)
tform = E2Transform(1, -1, 0.1, -0.2);

[Xp, Yp] = tform.reverse(X, Y); % arrays
[xp, yp] = tform.reverse(x, y); %symbolic
sig = E2_signature(f);
sigp = E2_signature(f(xp, yp));

figure(1)
subplot(1,2,1)
draw_image(f_numeric(X, Y), 'xlim', xlim, 'ylim', ylim)
subplot(1,2,2)
draw_image(f_numeric(Xp, Yp), 'xlim', xlim, 'ylim', ylim)

figure(2)
draw_signature(sig.evaluate(X, Y), 'facecolor', 'blue', 'facealpha', 0.5);
hold on
draw_signature(sigp.evaluate(X, Y), 'facecolor', 'red', 'facealpha', 0.5);


%% SE(2)
sig = SE2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% SA(2)
sig = SA2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% A(2)
sig = A2_signature(f);
draw_signature(sig.evaluate(X, Y))

%% PSL(3, R)
tform = PSL3RTransform(1, 0.1, 0.05, 0.8, 0.2, 0.3);

[Xp, Yp] = tform.reverse(X, Y); % arrays
[xp, yp] = tform.reverse(x, y); %symbolic
sig = PSL3R_signature(f);
sigp = PSL3R_signature(f(xp, yp));

S1 = sig.evaluate(X, Y);
S2 = sigp.evaluate(X, Y);
%%
figure(1)
clf
subplot(1,2,1)
draw_image(f_numeric(X, Y), 'xlim', xlim, 'ylim', ylim)
subplot(1,2,2)
draw_image(f_numeric(Xp, Yp), 'xlim', xlim, 'ylim', ylim)

figure(2)
clf
draw_signature(sig.evaluate(X, Y), 'facecolor', 'blue', 'facealpha', 0.5);
hold on
draw_signature(sigp.evaluate(X, Y), 'facecolor', 'red', 'facealpha', 0.5);

figure(3);
clf
levels = linspace(0, 3e-4, 7);
contour(S1{2}, S1{3}, S1{1}, levels, 'r');
hold on
contour(S2{2}, S2{3}, S2{1}, levels, 'b');
