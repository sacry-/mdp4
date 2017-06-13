import numpy as np

import tuberculosis as tb

from logger import Logger

logger = Logger(__name__, True).getLogger()


class AgentDistribution():
  """Agent creation statistics.

  Agent Distribution refers to the overall statistics of how
  all agents are distributed in the model at the start.
  """

  def __init__(self, S=100., L=10., I=1., R=0.):
    """
    Args:
      N (int): Numbers of agents.
    """
    N = S + L + I + R
    self.S = S
    self.L = L
    self.I = I
    self.R = R
    self.N = int(N)
    self.pop_density = [S/N, L/N, I/N, R/N]

    # Life expectancy - mu - stdev
    self.le = np.random.normal(80, 10, self.N)
    self.le_max = max(self.le)

    # Age - mu - stdev
    age_dist = np.random.gamma(2., 15., self.N)
    self.age = age_dist[age_dist < self.le_max]

    # trials, chance, repeats
    self.vaccinated = np.random.binomial(1, 0.1, self.N)

    # For correct times
    self.time_unit = lambda t: (t / 12.0)

    # Birth
    self.birth = self.time_unit(0.01)

    # Variable densities
    self.hiv_density = [0.9, 0.1]
    self.treatment_density = [0.3, 0.7]
    self.immune_density = [0.8, 0.2]

  def sample_le(self, age):
    le = np.random.choice(self.le)

    if age > le:
      le = min(self.le_max, age + 1)

    return le

  def sample_age(self):
    """
      returns a sample age (int)
    """
    return np.random.choice(self.age)

  def sample_vaccinated(self):
    """ One sample from a binominal distribution
    returns:
      if sample is vaccinated (bool)
    """
    return np.random.choice(self.vaccinated) ==  1

  def sample_state(self):
    """ Sample over a distribution skewed on susceptibles
    returns:
      initial state the sample is in
    """
    return np.random.choice(tb.STATES, p=self.pop_density)

  def sample_hiv(self):
    """ One sample from a binominal distribution
    returns:
      if sample has hiv (bool)
    """
    return self.binom_choice(p=self.hiv_density)

  def sample_treatment(self):
    """ One sample from a binominal distribution
    returns:
      if sample receives treatment (bool)
    """
    return self.binom_choice(self.treatment_density)

  def sample_immune_diseases(self):
    """ One sample from a binominal distribution
    returns:
      if sample receives treatment (bool)
    """
    return self.binom_choice(self.immune_density)

  def generate_sample(self):
    age = self.sample_age()

    return {
      'state' : self.sample_state(),
      'age' : age,
      'birth' : self.birth,
      'le' : self.sample_le(age),
      'vaccinated' : self.sample_vaccinated(),
      'treatment' : self.sample_treatment(),
      'hiv' : self.sample_hiv(),
      'immune_diseases' : self.sample_immune_diseases()
    }

  def generate_newborn_sample(self, parent):
    sample = self.generate_sample()
    sample["age"] = 1
    sample["vaccinated"] = self.binom_choice()
    if parent.hiv:
      sample["hiv"] = self.binom_choice()
    sample["immune_diseases"] = self.sample_immune_diseases()
    return sample

  def binom_choice(self, p=[.5, .5]):
    return np.random.choice([0, 1], p=p) == 1


