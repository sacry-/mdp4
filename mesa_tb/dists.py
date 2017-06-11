import matplotlib.pyplot as plt
import numpy as np
import scipy.special as sps

from collections import Counter

def bar_plot(dist):
  count, bins, ignored = plt.hist(dist, 50, normed=True)
  y = bins**(shape-1)*(np.exp(-bins/scale) /
                       (sps.gamma(shape)*scale**shape))
  plt.plot(bins, y, linewidth=2, color='r')
  plt.show()
