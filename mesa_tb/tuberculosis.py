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
  [.0, .45, .05, .5]
])
TRANS = { state: PROBS[i] for i, state in enumerate(STATES) }
INDICES = {state: i for i, state in enumerate(STATES)}


def next_state(h):
  state = h.state

  if h.vaccinated:
    return R

  aging_chance = aging(h.age, h.le)

  if state == S:
    if infect(h.inf_cm(), h.inf_nb()):
      state = SState(h.hiv, h.immune_diseases, aging_chance)

  elif state == L:
    state = LState(h.treatment, h.hiv, h.immune_diseases, aging_chance)

  elif state == I:
    state = IState(h.treatment, h.hiv, h.immune_diseases, aging_chance)

  elif state == R:
    if infect(h.inf_cm(), h.inf_nb()):
      state = RState(h.treatment, aging_chance)

  else:
    raise Exception("'state={}' must be in {}!".format(state, ", ".join(STATES)))

  return state

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
def nprob(seq):
  """Normalizes sequence to sum to exactly 1.0
  """
  arr = np.array(seq)
  indices = arr < 0
  arr[indices] = 0
  arr /= arr.sum()
  return arr

def prob(trans_row):
  return np.random.choice(STATES, p=nprob(trans_row))

def prob_row(state):
  return np.array(TRANS[S])

def aging(age, max_age):
  return (age / max_age) * 0.001

INF_CM_RISK = 0.3
INF_NB_RISK = 0.1

def infect(inf_cm, inf_nb):
  # Risk that cellmate infects you
  cm_risk = len(inf_cm) * INF_CM_RISK
  # Risk that neighbor infects you
  nb_risk = len(inf_nb) * INF_NB_RISK
  # Total chance of infection
  inf_chance = cm_risk + nb_risk
  no_inf_chance = max(0, 1.0 - inf_chance)
  # binominal chance of 0 - not infected and 1 infected
  p = nprob([no_inf_chance, inf_chance])
  return np.random.choice([0, 1], p=p) == 1


HIV_RISK = 0.4
IMMUNE_RISK = 0.1
TREATMENT_CHANCE = 0.4

def estimate_risk(states, ps, ns, risk):
  pids = [INDICES[s] for s in ps]
  nids = [INDICES[s] for s in ns]
  other = np.setdiff1d([i for i in range(4)], pids + nids)
  states[pids] += risk
  states[nids] -= risk
  states[other] = 0
  return states

def SState(hiv, immune_diseases, aging_chance):
  s_probs = prob_row(S)

  if hiv:
    s_probs = estimate_risk(s_probs, [L], [S], HIV_RISK)

  if immune_diseases:
    s_probs = estimate_risk(s_probs, [L], [S], IMMUNE_RISK)

  s_probs = estimate_risk(s_probs, [L], [S], aging_chance)

  return prob(s_probs)

def LState(treatment, hiv, immune_diseases, aging_chance):
  l_probs = prob_row(L)

  if hiv:
    l_probs = estimate_risk(l_probs, [I], [L], HIV_RISK)

  if immune_diseases:
    l_probs = estimate_risk(l_probs, [I], [L], IMMUNE_RISK)

  if treatment:
    l_probs = estimate_risk(l_probs, [L], [I], TREATMENT_CHANCE)

  l_probs = estimate_risk(l_probs, [I], [L], aging_chance)

  return prob(l_probs)

def IState(treatment, hiv, immune_diseases, aging_chance):
  i_probs = prob_row(I)

  if hiv:
    i_probs = estimate_risk(i_probs, [I], [R], HIV_RISK)

  if immune_diseases:
    i_probs = estimate_risk(i_probs, [I], [R], IMMUNE_RISK)

  if treatment:
    i_probs = estimate_risk(i_probs, [R], [I], TREATMENT_CHANCE)

  i_probs = estimate_risk(i_probs, [I], [R], aging_chance)

  return prob(i_probs)

def RState(treatment, aging_chance):
  r_probs = prob_row(R)

  if treatment:
    r_probs = estimate_risk(r_probs, [R], [L, I], TREATMENT_CHANCE)

  r_probs = estimate_risk(r_probs, [L, I], [R], aging_chance)

  return prob(r_probs)

