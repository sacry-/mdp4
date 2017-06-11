from mesa import Agent, Model
from mesa.space import MultiGrid
from mesa.time import RandomActivation
import random
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


class AAgent(Agent):

  def __init__(self, unique_id, model):
    Agent.__init__(self, unique_id, model)

  def move_self(self, new_position):
    self.model.grid.move_agent(self, new_position)

  def neighborhood(self, pos=None):
    if not pos:
      pos = self.pos
    return self.model.grid.get_neighborhood(
      pos, moore=True, include_center=True
    )

  def cellmates(self, pos=None):
    if not pos:
      pos = self.pos
    return self.model.grid.get_cell_list_contents([pos])

  def die(self):
    if self.model.grid:
      self.model.grid._remove_agent(self.pos, self)
    self.model.schedule.remove(self)


class MoneyAgent(AAgent):
  """ An agent with fixed initial wealth."""
  def __init__(self, unique_id, model):
    AAgent.__init__(self, unique_id, model)
    self.wealth = 1

  def step(self):
    self.move()
    if self.wealth > 0:
      self.give_money()
    else:
      self.die()

  def move(self):
    new_position = random.choice(self.neighborhood())
    self.move_self(new_position)

  def give_money(self):
    cellmates = self.cellmates()
    if len(cellmates) > 1:
      other_agent = random.choice(cellmates)
      if other_agent.wealth > 0:
        other_agent.wealth += 1
        self.wealth -= 1

  def __repr__(self):
    return "{} ({})".format(self.unique_id, self.wealth)


class MoneyModel(Model):
  """A model with some number of agents."""
  def __init__(self, N, width, height):
    self.num_agents = N
    self.grid = MultiGrid(width, height, True)
    self.schedule = RandomActivation(self)
    self.running = True
    self.create_agents()

  def create_agents(self):
    for i in range(self.num_agents):
      a = MoneyAgent(1, self)
      self.schedule.add(a)
      # Add the agent to a random grid cell
      x = random.randrange(self.grid.width)
      y = random.randrange(self.grid.height)
      self.grid.place_agent(a, (x, y))

  def step(self):
    '''Advance the model by one step.'''
    print("{}".format(sorted([a.wealth for a in self.schedule.agents], key=lambda a: -a)))
    self.schedule.step()

  def wealths(self):
    return [a.wealth for a in self.schedule.agents]

def basic_model():
  def step(model):
    agent_counts = np.zeros((model.grid.width, model.grid.height))
    for cell in model.grid.coord_iter():
      cell_content, x, y = cell
      agent_count = len(cell_content)
      agent_counts[x][y] = agent_count
    plt.imshow(agent_counts, interpolation='nearest')
    plt.colorbar()
    plt.show()
    sleep(1.0)

  iterations = 100
  model = MoneyModel(N=20, width=10, height=10)
  for i in range(0, iterations):
    step(model)

  print("{} result: {} {}".format("-"*10, iterations, "-"*10))
  for agent in sorted(model.schedule.agents, key=lambda a: -a.wealth):
    print(agent)

def visualSimulation():
  from mesa.visualization.modules import CanvasGrid
  from mesa.visualization.ModularVisualization import ModularServer

  def agent_portrayal(agent):
    return {
      "Shape": "circle",
      "Filled": "true",
      "Layer": 0,
      "Color": "red",
      "r": 0.5
    }

  N = 25
  width = 7
  height = 5
  grid = CanvasGrid(agent_portrayal, width, height, 500, 500)
  server = ModularServer(MoneyModel, [grid], "Money Model", N, width, height)
  server.port = 9000
  server.launch()


visualSimulation()
