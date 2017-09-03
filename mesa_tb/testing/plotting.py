import matplotlib.pyplot as plt
plt.style.use('ggplot')

import numpy as np
import scipy.special as sps

from pystyler import beautiful_bins
from pystyler import hist_plot

def test_dist(N=1000):
  shape, scale = 2., 2.
  dist = np.random.gamma(shape, scale, N)
  _, bins, _ = hist_plot(dist)
  y_line = bins**(shape-1)*(np.exp(-bins/scale) /
      (sps.gamma(shape)*scale**shape))
  beautiful_bins(bins, y_line,
    title="Gamma distribution",
    x_label="Age",
    y_label="Percentage"
  )

def age_dist(N):
  le = max(np.random.normal(80, 10, N))
  shape, scale = 2., 15.
  age_dist = np.random.gamma(shape, scale, N)
  age_dist = age_dist[age_dist < le]
  _, bins, _ = hist_plot(age_dist)
  y_line = bins**(shape-1)*(np.exp(-bins/scale) /
      (sps.gamma(shape)*scale**shape))

  beautiful_bins(bins, y_line,
    title="Gamma distribution",
    x_label="Age",
    y_label="Percentage"
  )


def vaccinated_dist(N):
  shape, scale = 1, 0.1
  vaccinated_dist = np.random.binomial(shape, scale, N)
  plt.hist(vaccinated_dist, N, bins=[0, 1], normed=True, color='r', edgecolor='black', linewidth=0.5)

  plt.show()
  # beautiful_bins(vaccinated_dist, None,
  #   title="Binominal distribution",
  #   x_label="Vaccination",
  #   y_label="Percentage"
  # )


if __name__ == "__main__":
  age_dist(N=1000)

