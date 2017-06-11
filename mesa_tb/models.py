import random

from mesa.space import MultiGrid


class GridModel(object):

  def __init__(self, width, height, running=True):
    self.width = width
    self.height = height

    self.grid = MultiGrid(self.width, self.height, True)
    self.running = running

  def place_agent(self, agent):
    x = random.randrange(self.grid.width)
    y = random.randrange(self.grid.height)
    self.grid.place_agent(agent, (x, y))