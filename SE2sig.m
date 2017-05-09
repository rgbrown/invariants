function sig = SE2sig(h, F)
[Fx, Fy] = gradient(F, h);
[Fxx, Fxy] = gradient(Fx, h);
[~, Fyy] = gradient(Fy, h);

I0 = F;
I1 = 1/100*(Fx*Fx + Fy*Fy);
I2 = 1/100*(Fxx + Fyy);

sig = {I0, I1, I2};

end