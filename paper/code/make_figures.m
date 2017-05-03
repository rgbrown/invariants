%% Signature surface generation script
syms x y
f = exp(-x.^2 - sin(y).^2);
draw_image(f)

%% E(2)
sig = E2_signature(f);
draw_signature(sig)

%% SE(2)
sig = SE2_signature(f);
draw_signature(sig)

%% SA(2)
sig = SA2_signature(f);
draw_signature(sig)

%% A(2)
sig = A2_signature(f);
draw_signature(sig)

%% PSL(3, R)
sig = PSL3R_signature(f);
draw_signature(sig)
