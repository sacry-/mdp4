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
    current_state = self.tb.get_state(self.state)

    # Do stuff before movement

    print(self)
    self.move()

    # Do stuff after movement

    self.age += 1 # years
    if self.age > 100:
      self.die()

  def move(self):
    new_position = random.choice(self.neighborhood())
    self.move_self(new_position)

  def infected(self):
    return self.tb.infected(self.state)

  def __repr__(self):
    return "{} (s: {}, age: {}, vac: {}, hiv: {}, treat: {})".format(self.unique_id, self.state, self.age, self.vaccinated, self.hiv, self.treatment)


