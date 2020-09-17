import numpy as np
import matplotlib.pyplot as plt
import skimage.color
import skimage.transform
from scipy import interpolate
from sympy import symbols, diff
import sympy

class SpatialTransform:
    def __init__(self):
        raise NotImplementedError

    def forward_coordinates(self, *argv):
        raise NotImplementedError

    def reverse_coordinates(self, *argv):
        raise NotImplementedError

class A2Transform(SpatialTransform):
    def __init__(self, a, b, c, d, tx, ty):
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.det = a*d - b*c
        self.tx = tx
        self.ty = ty

    def forward_coordinates(self, x, y):
        xnew = self.a*x + self.b*y + self.tx
        ynew = self.c*x + self.d*y + self.ty
        return (xnew, ynew)

    def reverse_coordinates(self, x, y):
        xnew = 1/self.det*(self.d*(x - self.tx) - self.b*(y - self.ty))
        ynew = 1/self.det*(-self.c*(x - self.tx) + self.a*(y - self.ty))
        return (xnew, ynew)

class ImageBase:
    def __init__(self):
        raise NotImplementedError
    
    def compute_derivatives(self, order):
        raise NotImplementedError

    def transform(self, tform):
        raise NotImplementedError

class NumericImage(ImageBase):
    def __init__(self, I, xlim=None, ylim=None):
        self.F = I
        self.ny, self.nx = I.shape
        if xlim is None:
            self.xlim = [0, self.nx - 1]
            self.x = np.arange(self.nx)
            self.dx = 1

        else:
            self.xlim = xlim
            self.x = np.linspace(xlim[0], xlim[1], self.nx)
            self.dx = (xlim[1] - xlim[0])/(self.nx - 1)
        if ylim is None:
            self.ylim = [0, self.ny - 1]
            self.y = np.arange(self.ny)
            self.dy = 1
        else:
            self.ylim = ylim
            self.y = np.linspace(ylim[0], ylim[1], self.ny)
            self.dy = (ylim[1] - ylim[0])/(self.ny - 1)

    def compute_derivatives(self, order):
        derivs = [self.F]
        i = 0; # start index for differentiating next order of derivative
        # Method generates derivatives in the order f, fx, fy, fxx, fxy,
        # fyy, fxxx, fxxy, fxyy, fyyy, etc, reusing previous derivatives
        for n in range(1, order + 1):
            derivs.append(np.gradient(derivs[i], self.dx, axis=0, edge_order=2))
            for k in range(n):
                derivs.append(np.gradient(derivs[i+k], self.dy, axis=1, edge_order=2))
            i += n
        return derivs

    def transform(self, tform):
        def inverse_map(cr):
            return np.vstack(tform.reverse_coordinates(cr[:, 0], cr[:, 1])).T

        return NumericImage(skimage.transform.warp(self.F, inverse_map), xlim=self.xlim, ylim=self.ylim)

class SymbolicImage(ImageBase):
    def __init__(self, expr):
        # fun is a symbolic expression in the variables x, y
        self.f = expr

    def compute_derivatives(self, order):
        derivs = [self.f];
        x, y = symbols('x, y')
        for n in range(1, order + 1):
            for i in range(n + 1):
                derivs.append(diff(self.f, x, n-i, y, i))
        return derivs

    def transform(self, tform):
        x, y = symbols('x, y')
        xbar, ybar = tform.reverse_coordinates(x, y)
        fnew = self.f.subs([[x, xbar], [y, ybar]])
        return SymbolicImage(fnew)

def E2_signature(f):
    order = 2
    group = 'E2'
    f, fx, fy, fxx, fxy, fyy = f.compute_derivatives(order)
    I0 = f
    I1 = fx*fx + fy*fy
    I2 = fxx + fyy
    I3 = fx**2*fxx +2*fx*fy*fxy + fy**2*fyy # SE2
    I4 = fy**2*fxx -2*fx*fy*fxy + fx**2*fyy # SE2
    I5 = (-fx*fy*(fxx - fyy) + (fx**2 - fy**2)*fxy) #SE2
    I6 = fxx**2 + fyy**2 + 2*fxy**2
    return (I1, I2, I6)


def A2_signature(f):
    order = 3
    group = 'A2'

    f, fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy = f.compute_derivatives(order)

    C = fxx*fyy - fxy**2
    D = fy**2*fxx - 2*fx*fy*fxy + fx**2*fyy
    E = fxxx*fy**3 - 3*fxxy*fx*fy**2 + 3*fxyy*fx**2*fy - fyyy*fx**3
    denom = np.sqrt(C**6 + D**6 + E**4)
    return (f*C**3/denom, f*D**3/denom, f*E**2/denom)

if __name__ == "__main__":
    theta = np.pi/4
    tform = A2Transform(np.cos(theta), -np.sin(theta), np.sin(theta), np.cos(theta),3000,-1000)
    I = plt.imread('../images/close1.JPG')
    I = skimage.color.rgb2grey(I)
    F = NumericImage(I, xlim=[-1.5, 1.5], ylim=[-1, 1])
    F2 = F.transform(tform)
    D = F2.compute_derivatives(2)
    I3 = D[2]
    print(I3.max())
    plt.imshow(I3, cmap='gray')
    plt.show()
    
