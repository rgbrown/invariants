import invariants
import skimage.color
import skimage.transform
from skimage.filters import gaussian
import numpy as np
import matplotlib.pyplot as plt
from mayavi import mlab

theta = np.pi/4
tform = invariants.A2Transform(np.cos(theta), -np.sin(theta), np.sin(theta), np.cos(theta),3000,-1000)
I = plt.imread('../images/close1.JPG')
I = skimage.color.rgb2grey(I)
I = skimage.transform.rescale(I, 1/10.0, anti_aliasing=True)
I = gaussian(I, sigma=3)
F = invariants.NumericImage(I)
D = F.compute_derivatives(2)
s1, s2, s3 = invariants.E2_signature(F)

surf = mlab.mesh(10*s1, s2, 100*s3, color=(0, 0, 1))
mlab.show()



