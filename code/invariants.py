import numpy as np
import matplotlib.pyplot as plt
import skimage.color
import skimage.transform
from scipy import interpolate
from sympy import symbols, diff

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
        # Method is inefficient - involves calculating the same derivatives
        # multiple times, but easy to code
        for n in range(1, order + 1):
            for i in range(n + 1):
                D = self.F.copy()
                # Do x derivatives
                for _k in range(n - i):
                    D = np.gradient(D, self.dx, axis=0, edge_order=2)
                # Do y derivatives
                for _k in range(i):
                    D = np.gradient(D, self.dy, axis=1, edge_order=2)
                derivs.append(D)
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


if __name__ == "__main__":
    theta = np.pi/4
    tform = A2Transform(np.cos(theta), -np.sin(theta), np.sin(theta), np.cos(theta),3000,-1000)
    I = plt.imread('images/close1.JPG')
    I = skimage.color.rgb2grey(I)
    F = NumericImage(I, xlim=[-1.5, 1.5], ylim=[-1, 1])
    F2 = F.transform(tform)
    D = F2.compute_derivatives(2)
    I3 = D[2]
    print(I3.max())
    plt.imshow(I3, cmap='gray')
    plt.show()
    
#    def forward_image(self, F, xlim=None, ylim=None):
#        # For images, we treat the origin as being the centre of the image, just to make everything fit nicely
#        ny, nx = F.shape
#
#        def inverse_map(cr):
#            return np.vstack(self.reverse_coordinates(cr[:,0], cr[:,1])).T 
#
#        return warp(F, inverse_map)