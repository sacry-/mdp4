import random

from logger import Logger
from aagent import AAgent

import tuberculosis as tb


logger = Logger(__name__).getLogger()



class Human(AAgent):
  """ Human agent that is the basic part of the simulation."""

  def __init__(self, unique_id, model, attrs):
    AAgent.__init__(self, unique_id, model)

    self.age = attrs['age']
    self.birth = attrs['birth']
    self.life_expectancy = attrs['life_expectancy']
    self.vaccinated = attrs['vaccinated']
    self.state = attrs['state']
    self.treatment = attrs['treatment']
    self.hiv = attrs['hiv']
    self.state_history = []

  def step(self):
    self.move()
    self.aging()
    self.reproduce()

    state, tb_attributes = tb.next_state(
      self.state,
      vaccinated=self.vaccinated,
      treatment=self.treatment,
      hiv=self.hiv,
      immune_diseases=False, # TODO
      age=self.age
    )

    self.update_state(state)
    self.chance_of_death(tb_attributes)

    # Do stuff before movement
    logger.info(self)


  def move(self):
    new_position = random.choice(self.neighborhood())
    self.move_self(new_position)

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

  def update_state(self, state):
    self.state_history.append(self.state)
    self.state = state

  def chance_of_death(self, options):
    if self.age > self.life_expectancy:
      self.model.age_mortality += 1
      self.die()

    elif "death" in options:
      if options["death"] > random.uniform(.2, 1.0):
        self.model.tb_mortality += 1
        self.die()

  def reproduce(self):
    if random.random() < self.birth:
      self.model.reproduction += 1
      self.model.create_agent()

  def aging(self):
    self.age += 1

  def _report(self, msg):
    prop = logger.propagate
    logger.propagate = True
    logger.info("Agent<{}> {}!".format(self.unique_id, msg))
    logger.propagate = prop

  def __repr__(self):
    return "Agent<{}> (s: {}, age: {}, vac: {}, hiv: {}, treat: {})".format(self.unique_id, self.state, self.age, self.vaccinated, self.hiv, self.treatment)


