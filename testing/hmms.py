import numpy as np

from hmmlearn import hmm


PROBS = np.array([
  [.95, .05, .0, .0],
  [.0, .9, .1, .0],
  [.0, .0, .5, .5],
  [.35, .2, .05, .4]
])
model = hmm.GaussianHMM(n_components=4, n_iter=100, init_params="mcs")
model.startprob_ = np.array([0.7, 0.1, 0.1, 0.1])
model.transmat_ = PROBS

s = [
  [2, 0, 1],
  [1, 0, 0],
  [1, 0, 1],
  [0, 1, 0],
  [80, 8, 40]
]
print("FITIING..")
model.fit(s)
print("PREDICTING..")
print(model.predict(PROBS))

