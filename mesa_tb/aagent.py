import random

from mesa import Agent


class AAgent(Agent):

  def __init__(self, unique_id, model):
    Agent.__init__(self, unique_id, model)

  def move_self(self, new_position):
    self.model.grid.move_agent(self, new_position)

  def neighborhood(self, pos=None):
    if not pos:
      pos = self.pos

    return self.model.grid.get_neighborhood(pos, moore=True, include_center=True)

  def cellmates(self, pos=None):
    if not pos:
      pos = self.pos

    return self.model.grid.get_cell_list_contents([pos])

  def die(self):
    if self.model.grid:
      self.model.grid._remove_agent(self.pos, self)

    self.model.schedule.remove(self)


