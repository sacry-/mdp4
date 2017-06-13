import random

from logger import Logger
from aagent import AAgent

import tuberculosis as tb


logger = Logger(__name__).getLogger()


class TBAgent(AAgent):

  def __init__(self, unique_id, model):
    AAgent.__init__(self, unique_id, model)

  def subsceptible(self):
    return tb.subsceptible(self.state)

  def infected(self):
    return tb.infected(self.state)

  def exposed(self):
    return tb.exposed(self.state)

  def infectious(self):
    return tb.infectious(self.state)

  def recovered(self):
    return tb.recovered(self.state)

  def inf_nb(self):
    return [h for h in self.neighbors() if h.infectious()]

  def inf_cm(self):
    return [h for h in self.cellmates() if h.infectious()]



class Human(TBAgent):
  """ Human agent that is the basic part of the simulation."""

  def __init__(self, unique_id, model, attrs):
    TBAgent.__init__(self, unique_id, model)

    self.age = attrs['age']
    self.birth = attrs['birth']
    self.le = attrs['le']
    self.vaccinated = attrs['vaccinated']
    self.state = attrs['state']
    self.treatment = attrs['treatment']
    self.hiv = attrs['hiv']
    self.immune_diseases = attrs['immune_diseases']
    self.state_history = []

    self.time_exposed = 0
    self.time_infected = 0

  def step(self):
    self.move()
    self.aging()
    self.reproduce()

    state = tb.next_state(self)

    self.update_state(state)
    self.chance_of_death()

    logger.info(self)


  def move(self):
    new_position = random.choice(self.neighborhood())
    self.move_self(new_position)

  def update_state(self, state):
    self.state_history.append(self.state)
    self.state = state

  def chance_of_death(self):
    if self.age > self.le:
      self.model.age_mortality += 1
      self.die()

    elif self.infectious():
      if self.time_infected > random.uniform(0.5, 1.0):
        self.model.tb_mortality += 1
        self.die()

  def reproduce(self):
    if random.random() < self.birth:
      self.model.reproduction += 1
      self.model.create_newborn_agent(self)

  def aging(self):
    unit = self.model.time_unit(1)

    self.age += unit

    if self.exposed():
      self.time_exposed += unit
    elif self.infectious():
      self.time_infected += unit

  def _report(self, msg):
    prop = logger.propagate
    logger.propagate = True
    logger.info("Agent<{}> {}!".format(self.unique_id, msg))
    logger.propagate = prop

  def __repr__(self):
    return "Agent<{}> (s: {}, age: {}, vac: {}, hiv: {}, treat: {})".format(self.unique_id, self.state, self.age, self.vaccinated, self.hiv, self.treatment)


