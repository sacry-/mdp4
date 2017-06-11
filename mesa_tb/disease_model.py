# -*- coding: utf-8 -*-
import numpy as np

from mesa import Model
from mesa.time import RandomActivation
from mesa.datacollection import DataCollector

from agents import Human
from models import GridModel
from tuberculosis import Tuberculosis, STATES


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
    self.age = np.random.gamma(2., 9.5, self.N)
    # trials, chance, repeats
    self.vaccinated = np.random.binomial(1, 0.7, self.N)

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
    return np.random.choice(STATES, p=self.pop_density)

  def sample_hiv(self):
    """ One sample from a binominal distribution
    returns:
      if sample has hiv (bool)
    """
    return np.random.choice([0, 1], p=[0.99, 0.01]) == 1

  def sample_treatment(self):
    """ One sample from a binominal distribution
    returns:
      if sample receives treatment (bool)
    """
    return np.random.choice([0, 1], p=[0.4, 0.6]) == 1

  def generate_sample(self):
    return {
      'state' : self.sample_state(),
      'age' : self.sample_age(),
      'vaccinated' : self.sample_vaccinated(),
      'treatment' : self.sample_treatment(),
      'hiv' : self.sample_hiv()
    }


class DiseaseModel(Model, GridModel):
  """The basic disease model for Tuberculosis.

  Longer description here.

  Attributes: None
  """

  def __init__(self, agent_dist, width, height):
    """
    Args:
      agent_dist (AgentDistribution): Object describing Agents.
      width (int): Grid width.
      height (int): Grid height.
    """
    GridModel.__init__(self, width, height)

    self.number_of_agents = agent_dist.N
    self.agent_dist = agent_dist
    self.tb = Tuberculosis()

    self.schedule = RandomActivation(self)
    self.dc = DataCollector(model_reporters={
      "infected" : count_infections
    })

    self._create_agents()

  def _create_agents(self):
    for i in range(self.number_of_agents):
      attributes = self.agent_dist.generate_sample()
      agent = Human(i, self, attributes)
      self.schedule.add(agent)
      self.place_agent(agent)

  def step(self):
    # Collect data each step
    self.dc.collect(self)

    # Do the actual step
    self.schedule.step()


def count_infections(model):
  return count_agents(model, lambda a: a)

def count_agents(model, f, accu=0):
  """Generic reduce filter counter
  args:
    model (DiseaseModel) - with interface .grid.coord_iter()
    f - function with (any -> bool)
    accu - counter variable
  """
  for cell in model.grid.coord_iter():
    agents, x, y = cell
    for agent in agents:
      if f(agent):
        accu += 1
  return accu


