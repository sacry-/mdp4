import numpy as np

import matplotlib.pyplot as plt
plt.style.use('ggplot')


def hist_plot(dist):
  return plt.hist(dist, 50, normed=True, color='r', edgecolor='black', linewidth=0.5)

def beautiful_bins(bins, y_line, title="Test", x_label="X Label", y_label="Y Label", format="png"):
  plt.title(title)
  plt.plot(bins, y_line, linewidth=2, color='black')
  plt.xlabel(x_label)
  plt.ylabel(y_label)
  ax = plt.subplot(111)
  ax.set_ylim(ymin=0)
  ax.set_xlim(xmin=0)
  plt.savefig("./imgs/{}.{}".format(title.lower(), format), format=format)
  plt.show()