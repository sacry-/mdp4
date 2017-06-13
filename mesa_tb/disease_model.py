# -*- coding: utf-8 -*-
import numpy as np

from logger import Logger
from mesa import Model
from mesa.time import RandomActivation
from mesa.datacollection import DataCollector

from collections import Counter

from human import Human
from grid import Grid
from data_collection import count_subsceptibles, count_exposed, count_infectious, count_recovered, count_all


logger = Logger(__name__, True).getLogger()



class StatsReport():

  def __init__(self):
    pass

  def report(self):
    n = len(self.schedule.agents)
    scount = count_subsceptibles(self)
    ecount = count_exposed(self)
    icount = count_infectious(self)
    rcount = count_recovered(self)

    hivs = Counter([a.hiv for a in self.schedule.agents])
    treatments = Counter([a.treatment for a in self.schedule.agents])
    vaccinated = Counter([a.vaccinated for a in self.schedule.agents])
    logger.info("N: {}, S: {}, L: {}, I: {}, R: {}".format(n, scount, ecount, icount, rcount))
    logger.info("hiv: {}, treat: {}, vaccinated: {}".format(hivs, treatments, vaccinated))
    logger.info("age-m: {}, tb-m: {}, rep: {}".format(self.age_mortality, self.tb_mortality, self.reproduction))


class DiseaseModel(Model, Grid, StatsReport):
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
    Grid.__init__(self, width, height)

    self.number_of_agents = agent_dist.N
    self.time_unit = agent_dist.time_unit
    self.agent_dist = agent_dist

    self.schedule = RandomActivation(self)
    self.dc = DataCollector(model_reporters={
      "subsceptibles" : count_subsceptibles,
      "exposed" : count_exposed,
      "infectious" : count_infectious,
      "recovered" : count_recovered,
      "n" : count_all,
    })

    self.age_mortality = 0
    self.tb_mortality = 0
    self.reproduction = 0

    self.create_agents()

  def create_agents(self):
    for i in range(self.number_of_agents):
      self.create_agent(unique_id=i)

  def create_agent(self, unique_id=None):
    attributes = self.agent_dist.generate_sample()
    agent = Human(unique_id, self, attributes)
    self.schedule.add(agent)
    self.place_agent(agent)

  def create_newborn_agent(self, parent):
    unique_id = max([a.unique_id for a in self.schedule.agents]) + 1
    attributes = self.agent_dist.generate_newborn_sample(parent)
    agent = Human(unique_id, self, attributes)
    self.schedule.add(agent)
    self.place_agent(agent)

  def step(self):
    # Collect data each step
    self.dc.collect(self)

    self.report()

    # Do the actual step
    self.schedule.step()


