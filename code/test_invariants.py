import invariants
import skimage.color
import skimage.transform
from skimage.filters import gaussian
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d

theta = np.pi/4
tform = invariants.A2Transform(np.cos(theta), -np.sin(theta), np.sin(theta), np.cos(theta),3000,-1000)
I = plt.imread('../images/close1.JPG')
I = skimage.color.rgb2grey(I)
I = skimage.transform.rescale(I, 1/10.0, anti_aliasing=True)
I = gaussian(I, sigma=3)
F = invariants.NumericImage(I)
D = F.compute_derivatives(2)
s1, s2, s3 = invariants.A2_signature(F)



fig1 = plt.figure()
plt.imshow(D[3], cmap='gray')

fig2 = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(s1, s2, s3, cmap='viridis', edgecolor='none', shade=True)

plt.show()

