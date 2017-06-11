# -*- coding: utf-8 -*-
import numpy as np

from mesa import Model
from mesa.time import RandomActivation

from agents import Human
from models import GridModel
from tuberculosis import Tuberculosis


class AgentDistribution():
  """Agent creation statistics.

  Agent Distribution refers to the overall statistics of how
  all agents are distributed in the model at the start.
  """

  def __init__(self, N):
    """
    Args:
      N (int): Numbers of agents.
    """
    self.S = 100
    self.L = 10
    self.I = 1
    self.R = 0
    self.N = self.S + self.L + self.I + self.R

  def age(self, mu=50, sigma=50):
    mu, sigma = 40, 0.1 # mean and standard deviation

    s = np.random.normal(mu, sigma, 1000)


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
    self._create_agents()
    self.dc = DataCollector(model_reporters={
      # TODO: add stats
      "infectious": lambda x: x,
    })

  def _create_agents(self):
    for i in range(self.number_of_agents):
      agent = Human(i, self, attributes)
      self.schedule.add(agent)
      self.place_agent(agent)


  def step(self):
    # Collect data each step
    self.dc.collect(self)

    # Do the actual step
    self.schedule.step()







