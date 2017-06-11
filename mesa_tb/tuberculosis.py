import numpy as np

# S - Subsceptible to TB
S = "S"
# L - Latently exposed (not infectious)
L = "L"
# I - Infected in an active state
I = "I"
# R - Recovered means all that live having had TB
R = "R"

STATES = [ S, L, I, R ]
INFECTED = [L, I]


class Tuberculosis():

  def __init__(self):
    self.treatment_prob = 0
    self.hiv_prob = 0
    self.id_prob = 0

    self.max_age = 100
    self.age_prob = 0.1

  def get_state(self, state, vaccinated=False, treatment=True, hiv=False, immune_diseases=False, age=30):
    if state == S:
      self.SState(vaccinated, hiv, immune_diseases, age)

    elif state == L:
      self.LState(treatment, hiv, immune_diseases, age)

    elif state == I:
      self.IState(treatment, hiv, immune_diseases, age)

    elif state == R:
      self.RState(treatment, age)

    else:
      raise "'state={}' must be in {}!".format(state, ", ".join(STATES))

  def SState(self, vaccinated, hiv, immune_diseases, age):
    print("S")

  def LState(self, treatment, hiv, immune_diseases, age):
    print("S")

  def IState(self, treatment, hiv, immune_diseases, age):
    print("S")

  def RState(self, treatment, age):
    print("S")

  def infected(self, state):
    return state in [L, I]

  def age_chance(self, age):
    age_prob = ( (age if age > 10 else 0) / self.max_age ) * self.age_prob
    prob = prob * (1 + age_prob)
    return prob


