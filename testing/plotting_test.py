import matplotlib.pyplot as plt
import numpy as np



def plot_hist(count, bins, ignored, mu, sigma, s):
  plt.plot(bins, 1 / (sigma * np.sqrt(2 * np.pi) ) * np.exp( - (bins - mu)**2 / (2 * sigma**2) ), linewidth=2, color='r')


mu = 80
sigma = 10
s = np.random.normal(mu, sigma, 1000)
norm_max = max(s)
count, bins, ignored = plt.hist(s, 30, normed=True)
plot_hist(count, bins, ignored, mu, sigma, s)


mu = 2.
sigma = 15.
s = np.random.gamma(mu, sigma, 1000)
s = s[s < norm_max]
print(len(s))
count, bins, ignored = plt.hist(s, 30, normed=True)
plot_hist(count, bins, ignored, mu, sigma, s)

plt.show()