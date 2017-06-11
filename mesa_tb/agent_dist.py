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

    # mean, std, samples
    self.age = np.random.gamma(2., 9, self.N)
    # trials, chance, repeats
    self.vaccinated = np.random.binomial(1, 0.3, self.N)

    # Birth
    self.birth = 0.01

    # Mortality
    self.life_expectancy = 80

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
    return np.random.choice([0, 1], p=[0.7, 0.3]) == 1

  def sample_treatment(self):
    """ One sample from a binominal distribution
    returns:
      if sample receives treatment (bool)
    """
    return np.random.choice([0, 1], p=[0.8, 0.2]) == 1

  def generate_sample(self):
    return {
      'state' : self.sample_state(),
      'age' : self.sample_age(),
      'birth' : self.birth,
      'life_expectancy' : self.life_expectancy,
      'vaccinated' : self.sample_vaccinated(),
      'treatment' : self.sample_treatment(),
      'hiv' : self.sample_hiv()
    }


