import random

from mesa import Agent


class AAgent(Agent):

  def __init__(self, unique_id, model):
    Agent.__init__(self, unique_id, model)

    self.movement_radius = 1
    self.infection_radius = 6
    self.moore = True
    self.include_center = True

  def move_self(self, new_position):
    self.model.grid.move_agent(self, new_position)

  def cellmates(self):
    return self.model.grid.get_cell_list_contents([self.pos])

  def neighborhood(self):
    return self.model.grid.get_neighborhood(self.pos,
      include_center=self.include_center,
      radius=self.movement_radius,
      moore=self.moore
    )

  def neighbors(self):
    return self.model.grid.get_neighbors(self.pos,
      include_center=self.include_center,
      radius=self.infection_radius,
      moore=self.moore
    )

  def die(self):
    if self.model.grid:
      self.model.grid._remove_agent(self.pos, self)

    self.model.schedule.remove(self)


