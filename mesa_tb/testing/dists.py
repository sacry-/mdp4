import matplotlib.pyplot as plt
import numpy as np
import scipy.special as sps


d = np.random.dirichlet((10, 5), 20).transpose()


d = np.random.exponential(scale=1.0)
print(d)

shape, scale = 2., 2. # mean=4, std=2*sqrt(2)
s = np.random.gamma(shape, scale, 1000)
count, bins, ignored = plt.hist(s, 50, normed=True)
y = bins**(shape-1)*(np.exp(-bins/scale) /
                     (sps.gamma(shape)*scale**shape))
plt.plot(bins, y, linewidth=2, color='r')
plt.show()