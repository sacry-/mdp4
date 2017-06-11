import numpy as np

from logger import Logger


logger = Logger(__name__).getLogger()


# S - Subsceptible to TB
S = "S"
# L - Latently exposed (not infectious)
L = "L"
# I - Infected in an active state
I = "I"
# R - Recovered from TB either through death OR cured
R = "R"

STATES = [ S, L, I, R ]
INFECTED = [L, I]

"""
rows ~ States
columns ~ States
|States| x |States| cooccurence matrix with probabilities

  S - .95 -> S,
  S - .05 -> L,
  S - .0 -> I,
  S - .0 -> R

  etc.
"""
PROBS = np.array([
  [.95, .05, .0, .0],
  [.0, .9, .1, .0],
  [.0, .1, .7, .2],
  [.35, .2, .05, .4]
])
TRANS = { state: PROBS[i] for i, state in enumerate(STATES) }


def next_state(state, vaccinated=False, treatment=True, hiv=False, immune_diseases=False, age=30):
  next_state = state
  opts = {}

  if vaccinated:
    return RState(treatment, age)

  if state == S:
    next_state, opts = SState(hiv, immune_diseases, age)

  elif state == L:
    next_state, opts = LState(treatment, hiv, immune_diseases, age)

  elif state == I:
    next_state, opts = IState(treatment, hiv, immune_diseases, age)

  elif state == R:
    next_state, opts = RState(treatment, age)

  else:
    raise Exception("'state={}' must be in {}!".format(state, ", ".join(STATES)))

  return (next_state, opts)

def subsceptible(state):
  return state == S

def exposed(state):
  return state == L

def infectious(state):
  return state == I

def recovered(state):
  return state == R

def infected(state):
  return exposed(state) or infectious(state)


# Private
def normal_prob(seq):
  """Normalizes sequence to sum to exactly 1.0
  """
  arr = np.array(seq)
  indices = arr < 0
  arr[indices] = 0
  arr /= arr.sum()
  return arr

def prob(trans_row):
  p = normal_prob(trans_row)
  return np.random.choice(STATES, p=p)

def SState(hiv, immune_diseases, age):
  tmp = list(TRANS[S])
  s_probs = tmp[:]

  s_state = s_probs[0]
  l_state = s_probs[1]
  if hiv:
    s_state -= .4
    l_state += .4

  if immune_diseases:
    s_state -= .2
    l_state += .2

  aging_rate = (age / 100) * 0.1
  s_state = s_state - l_state
  l_state = l_state + l_state
  s_probs[0] = s_state
  s_probs[1] = l_state

  return (prob(s_probs), {})

def LState(treatment, hiv, immune_diseases, age):
  tmp = list(TRANS[L])
  l_probs = tmp[:]

  l_state = l_probs[1]
  i_state = l_probs[2]
  if hiv:
    l_state -= .5
    i_state += .5

  if immune_diseases:
    l_state -= .1
    i_state += .1

  if treatment:
    l_state += .4
    i_state -= .4

  aging_rate = (age / 100) * 0.1
  l_state = l_state - i_state
  i_state = i_state + i_state
  l_probs[1] = l_state
  l_probs[2] = i_state

  return (prob(l_probs), {})

def IState(treatment, hiv, immune_diseases, age):
  tmp = list(TRANS[I])
  i_probs = tmp[:]

  i_state = i_probs[2]
  r_state = i_probs[3]
  d_state = .1

  if hiv:
    d_state += .4
    i_state += .2
    r_state -= .2

  if immune_diseases:
    d_state += .1
    i_state += .1
    r_state -= .1

  if treatment:
    d_state -= .5
    i_state -= .4
    r_state += .4

  aging_rate = (age / 100) * 0.1

  d_state = d_state + aging_rate
  i_state = i_state - i_state
  r_state = r_state + i_state
  i_probs[2] = i_state
  i_probs[3] = r_state

  return (prob(i_probs), {"death" : max(d_state, 0)})

def RState(treatment, age):
  return (prob(TRANS[R]), {})

