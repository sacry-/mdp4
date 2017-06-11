import numpy as np


def count_infections(model):
  return count_agents(model, lambda a: a.infected())

def avg_age(model):
  return avg_agents(model, lambda a: a.age)

def list_age(model):
  return list(map_fil_agents(model, t=lambda a: a.age))


# Private
def map_fil_agents(model, p=lambda a: a, t=lambda a: a):
  for cell in model.grid.coord_iter():
    agents, x, y = cell
    for agent in agents:
      if p(agent): yield t(agent)

def avg_agents(model, f):
  acc = []
  for cell in model.grid.coord_iter():
    agents, x, y = cell
    for agent in agents:
      acc.append( f(agent) )
  return np.mean(acc)

def count_agents(model, f, accu=0):
  """Generic reduce filter counter
  args:
    model (DiseaseModel) - with interface .grid.coord_iter()
    f - function with (any -> bool)
    accu - counter variable
  """
  for cell in model.grid.coord_iter():
    agents, x, y = cell
    for agent in agents:
      if f(agent):
        accu += 1
  return accu