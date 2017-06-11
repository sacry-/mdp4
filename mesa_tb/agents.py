import random

from aagent import AAgent


class Human(AAgent):
  """ Human agent that is the basic part of the simulation."""
  def __init__(self, unique_id, model, attrs):
    AAgent.__init__(self, unique_id, model)

    self.tb = self.model.tb
    self.age = attrs['age']
    self.vaccinated = attrs['vaccinated']
    self.state = attrs['state']
    self.treatment = attrs['treatment']
    self.hiv = attrs['hiv']

  def step(self):
    self.move()

    self.tb.get_state(self.state)

    self.age += 1 # years
    if age > 100:
      self.die()

  def move(self):
    new_position = random.choice(self.neighborhood())
    self.move_self(new_position)

  def infected(self):
    return self.tb.infected(self.state)

  def __repr__(self):
    return "{} ({})".format(self.unique_id, self.age)


