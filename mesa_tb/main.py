import numpy as np
from math import sqrt
import numbers

from mesa.visualization.modules import CanvasGrid
from mesa.visualization.ModularVisualization import ModularServer
from mesa.visualization.modules import ChartModule

from disease_model import DiseaseModel
from agent_dist import AgentDistribution


def get_dimensions(n):
  divisors = []

  for current_div in range(n):
    if n % float(current_div + 1) == 0:
      divisors.append(current_div + 1)
  w_index = min(range(len(divisors)), key=lambda i: abs(divisors[i]-sqrt(n)))
  h_index = w_index + 1

  width = divisors[w_index]
  height = divisors[h_index]

  return width, height

def color(name):
  if name == "blue":
    return "#6495ED"

  elif name == "red":
    return "#A52A2A"

  elif name == "yellow":
    return "#FF8C00"

  elif name == "green":
    return "#006400"

  return "#000000"


def agent_portrayal(agent):
  b = {
    "Filled": "true"
  }

  if agent.subsceptible():
    b.update({
      "Shape": "circle",
      "r": 0.5,
      "Layer": 3,
      "Color": color("blue"),
    })

  if agent.recovered():
    b.update({
      "Shape": "circle",
      "r": 0.4,
      "Layer": 2,
      "Color": color("green"),
    })

  if agent.exposed():
    b.update({
      "Shape": "rect",
      "w" : .5,
      "h" : .5,
      "Layer": 1,
      "Color": color("yellow"),
    })

  if agent.infectious():
    b.update({
      "Shape": "rect",
      "w" : .5,
      "h" : .5,
      "Layer": 0,
      "Color": color("red"),
    })

  if not "Layer" in b:
    print("{} - Layer not found!".format(agent))

  return b


if __name__ == "__main__":
  config = dict(S=2000., L=0., I=6., R=0.)
  # config = dict(S=100., L=6., I=2., R=0.)
  agent_dist = AgentDistribution(**config)
  width, height = get_dimensions(agent_dist.N)
  pixel = 750
  grid = CanvasGrid(agent_portrayal, width, height, pixel, pixel)

  li = ChartModule([{"Label": "exposed", "Color": color("yellow")}, {"Label": "infectious", "Color": color("red")}], data_collector_name='dc', canvas_height=300, canvas_width=pixel)
  n = ChartModule([{"Label": "n", "Color": "Black"}], data_collector_name='dc', canvas_height=300, canvas_width=pixel)
  sr = ChartModule([{"Label": "subsceptibles", "Color": color("blue")}, {"Label": "recovered", "Color": color("green")}], data_collector_name='dc', canvas_height=300, canvas_width=pixel)

  server = ModularServer(DiseaseModel, [li, sr, n, grid], "Disease Model", agent_dist, width, height)
  server.port = 9000
  server.launch()



