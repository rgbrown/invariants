# Create a test image
from invariants import *
import numpy as np
import matplotlib.pyplot as plt

# Create a two test functions which produce similar looking images. These
# will be used in a classification experiment
def f(x, y):
    return 0.5*(1 + np.sin(4*x) * np.cos(7*y)) * 2*np.exp(-10*((x - 0.1)**2
        + (y+0.2)**2))

def g(x, y):
    return 0.5*(1 + np.sin(5*x) * np.cos(6*y)) * 2*np.exp(-12*((x - 0.1)**2
        + (y+0.2)**2))

def create_current(h, m, n, k):
    X, Y = np.meshgrid(np.arange(-1.5, 1.5, h), np.arange(-1.5, 1.5, h))
    F = f(X, Y)
    sig = SA2signature(F, h)

    surf = InvariantSurface(sig[0], sig[1], sig[2])
    return surf.current(m, n, k)

# Test convergence of current operation
m, n, k = 2, 2, 2
h = 0.05
x0 = create_current(h, m, n, k)
for i in range(6):
    h = h/2
    x1 = create_current(h, m, n, k)
    print(np.abs(x1 - x0) / np.abs(x0))
    x0 = x1











