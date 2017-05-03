import numpy as np

# transformation group signatures
def SA2signature(F, h=1):
    """ All the degree three and lower transvectants"""
    Fx, Fy = np.gradient(F, h)
    Fxx, Fxy = np.gradient(Fx, h)
    Fyx, Fyy = np.gradient(Fy, h)
    Fxxx, Fxxy = np.gradient(Fxx, h)
    Fxyx, Fxyy = np.gradient(Fxy, h)
    Fyyx, Fyyy = np.gradient(Fyy, h)
    
    I0 = F
    I1 = Fxx*Fyy - Fxy**2
    I2 = Fy**2*Fxx - 2*Fx*Fy*Fxy + Fx**2*Fyy
    I3 = (Fyy*Fxxy**2 - Fyy*Fxxx*Fxyy - Fxy*Fxxy*Fxyy + Fxx*Fxyy**2 +
            Fxy*Fxxx*Fyyy - Fxx*Fxxy*Fyyy)
    I4 = (Fy*Fyy*Fxxx - 2*Fy*Fxy*Fxxy - Fx*Fyy*Fxxy + Fy*Fxx*Fxyy +
            2*Fx*Fxy*Fxyy - Fx*Fxx*Fyyy)
    
    return (I0, I1, I2, I3, I4)

def SE2signature(F, h=1):
    Fx, Fy = np.gradient(F, h)
    Fxx, Fxy = np.gradient(Fx, h)
    Fyx, Fyy = np.gradient(Fy, h)

    I0 = F # function value
    I1 = Fx*Fx + Fy*Fy
    I2 = Fxx + Fyy
    return (I0, I1, I2)

def signed_area(ax, ay, bx, by, cx, cy):
    """ Compute signed area of a triangle

    Arguments:
    ax, ay, bx, by, cx, cy -- the x and y coordinates of the (ordered)
    vertices a, b, c of the triangle
    """
    return 0.5*(ax*by - ay*bx + bx*cy - by*cx + cx*ay - cy*ax)

def triangle_areas(X, Y):
    """ Compute signed area of triangulation of gridded mesh

    Arguments:
    X, Y -- 2D arrays of X, Y coordinates. Each grid square is split into
    two triangles and the oriented area computed
    """

    ax, ay = X[0:-1, 0:-1], Y[0:-1, 0:-1]
    bx, by = X[0:-1, 1:], Y[0:-1, 1:]
    cx, cy = X[1:, 0:-1], Y[1:, 0:-1]
    dx, dy = X[1:, 1:], Y[1:, 1:]
    
    # lower is triangle ACD, upper is triangle ADB (anticlockwise
    # orientation) if indices of X and Y are drawn as matrix rows/ columns
    lower = signed_area(ax, ay, cx, cy, dx, dy)
    upper = signed_area(ax, ay, dx, dy, bx, by)
        
    return lower, upper

def compute_centroids(I):
    """ Compute mean value of a quantity on a grid subdivided into
    triangles

    """
    lower = 1./3. * (I[0:-1, 0:-1] + I[1:, 0:-1] + I[1:, 1:])
    upper = 1./3. * (I[0:-1, 0:-1] + I[1:, 1:] + I[0:-1, 1:])
    return lower, upper

class InvariantSurface():
    def __init__(self, I0, I1, I2):
        self.centroids = [compute_centroids(I) for I in (I0, I1, I2)]
    
        self.dxdy_l, self.dxdy_u = triangle_areas(I0, I1)
        self.dydz_l, self.dydz_u = triangle_areas(I1, I2)
        self.dxdz_l, self.dxdz_u = triangle_areas(I0, I2)

    def current(self, m, n, k):
        integrand_l = (self.centroids[0][0]**m * 
                self.centroids[1][0]**n *
                self.centroids[2][0]**k)
        integrand_u = (self.centroids[0][1]**m * 
                self.centroids[1][1]**n *
                self.centroids[2][1]**k)
        
        return np.array([
            (integrand_l*self.dxdy_l + integrand_u*self.dxdy_u).sum(),
            (integrand_l*self.dydz_l + integrand_u*self.dydz_u).sum(),
            (integrand_l*self.dxdz_l + integrand_u*self.dxdz_u).sum()])

# Random transformations 
from numpy.random import rand, randn, standard_normal
import numpy.random
from scipy.fftpack import ifft2, idct, dct

class RandomEquiaffine():
    def __init__(self):
        theta = 2*np.pi*np.random.rand();
        self.A =  np.array([[np.cos(theta), -np.sin(theta)],[np.sin(theta),
            np.cos(theta)]]) + np.random.rand(2,2)
        if np.linalg.det(self.A) < 0:
            self.A[:, 1] = -self.A[:, 1]
        self.A = self.A / np.sqrt(np.linalg.det(self.A))
        self.b = 0.1 * randn(2)
        self.Ainv = np.linalg.inv(self.A)
        self.binv = -np.linalg.solve(self.A, self.b)
    
    def forward_transform(self, f, X, Y):
        return f(self.Ainv[0,0]*X + self.Ainv[0,1]*Y + self.binv[0], 
                 self.Ainv[1,0]*X + self.Ainv[1,1]*Y + self.binv[1])

class RandomSE2():
    def __init__(self):
        theta = 2*np.pi*np.random.rand();
        self.A =  np.array([[np.cos(theta), -np.sin(theta)],[np.sin(theta),
            np.cos(theta)]])
        self.b = 0.1 * randn(2)
        self.Ainv = self.A.T
        self.binv = -np.linalg.solve(self.A, self.b)
    
    def forward_transform(self, f, X, Y):
        return f(self.Ainv[0,0]*X + self.Ainv[0,1]*Y + self.binv[0], 
                 self.Ainv[1,0]*X + self.Ainv[1,1]*Y + self.binv[1])


def smooth_noise(shape, width=1, decay=100):
    m, n = shape
    m_freq = np.arange(m) / m
    n_freq = np.arange(n) / n
    Mf, Nf = np.meshgrid(n_freq, m_freq)
    
    W = width*standard_normal(shape) * np.exp(-decay*(Mf + Nf))
    W[0,0] = 0
    
    X = idct(idct(W, axis=0), axis=1)    
    return X

