function sig = Sim2_signature(F, varargin)
[~, Fx, Fy, Fxx, Fxy, Fyy] = compute_derivatives(F, 2, varargin{:});
J1 = Fx.*Fx + Fy.*Fy;
J2 = Fxx + Fyy;
J3 = sqrt(Fxx.*Fxx + 2*Fxy.*Fxy + Fyy.*Fyy);
denom = sqrt(J1.*J1 + J2.*J2 + J3.*J3);
J1 = J1 ./ denom;
J2 = J2 ./ denom;
J3 = J3 ./ denom;

I1 = acos(J3);
I2 = atan2(J2, J1);

sig = {F, I1, I2};