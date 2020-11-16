from sympy.abc import x, y
from sympy import lambdify, sin, exp, pi
import numpy as np
from mayavi import mlab
import matplotlib.pyplot as plt
import invariants

## Start by setting up the function and transformed function
f = invariants.SymbolicImage(exp(-2*x**2 - 4*sin(0.5*x**2 + y)**2))
theta = np.pi/4
c = np.cos(theta)
s = np.sin(theta)
tform = invariants.E2Transform(1, 3*np.pi/4, 0, 0)
f2 = f.transform(tform)

## Plot the image and transformed image
X, Y = np.mgrid[-1:1:200j, -1:1:200j]
I1 = lambdify([x, y], f.f, "numpy")(X, Y)
I2 = lambdify([x, y], f2.f, "numpy")(X, Y)

fig, (ax1, ax2) = plt.subplots(1, 2)
ax1.imshow(I1, vmin=0, vmax=1)
ax2.imshow(I2, vmin=0, vmax=1)
plt.show()

##
S = invariants.E2_signature(f)
Sb = invariants.E2_signature(f2)
X, Y = np.mgrid[-1:1:200j, -1:1:200j]
Sn = [lambdify((x, y), S[i], "numpy")(X, Y) for i in range(3)]
Sbn = [lambdify((x, y), Sb[i], "numpy")(X, Y) for i in range(3)]


mlab.mesh(10*Sn[0], Sn[1], Sn[2], color=(0, 0, 1), opacity=0.5)
mlab.mesh(10*Sbn[0], Sbn[1], Sbn[2], color=(1, 0, 0), opacity=0.5)
mlab.show()

