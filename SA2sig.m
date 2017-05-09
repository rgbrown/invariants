function sig = SA2sig(h, F)
[Fx, Fy] = gradient(F, h);
[Fxx, Fxy] = gradient(Fx, h);
[~, Fyy] = gradient(Fy, h);
[Fxxx, Fxxy] = gradient(Fxx, h);
[~, Fxyy] = gradient(Fxy, h);
[~, Fyyy] = gradient(Fyy, h);

I0 = F;
I1 = Fxx.*Fyy - Fxy.^2;
I2 = Fy.^2.*Fxx - 2*Fx.*Fy.*Fxy + Fx.^2.*Fyy;
I3 = Fyy.*Fxxy.^2 - Fyy.*Fxxx.*Fxyy - Fxy.*Fxxy.*Fxyy + ...
    Fxx.*Fxyy.^2 + Fxy.*Fxxx.*Fyyy - Fxx.*Fxxy.*Fyyy;
I4 = Fy.*Fyy.*Fxxx - 2*Fy.*Fxy.*Fxxy - Fx.*Fyy.*Fxxy + Fy.*Fxx.*Fxyy + ...
    2*Fx.*Fxy.*Fxyy - Fx.*Fxx.*Fyyy;

sig = {I0, I1, I2, I3, I4};

end