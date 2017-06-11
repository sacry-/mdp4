import numpy as np
from math import sqrt
import numbers

from mesa.visualization.modules import CanvasGrid
from mesa.visualization.ModularVisualization import ModularServer
from mesa.visualization.modules import ChartModule

from disease_model import DiseaseModel
from agent_dist import AgentDistribution


def get_dimensions(n):
  tempSqrt = sqrt(n)
  divisors = []
  currentDiv = 1
  for currentDiv in range(n):
    if n % float(currentDiv + 1) == 0:
      divisors.append(currentDiv+1)
  hIndex = min(range(len(divisors)), key=lambda i: abs(divisors[i]-sqrt(n)))
  wIndex = hIndex + 1
  return divisors[hIndex], divisors[wIndex]

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
    "Filled": "true",
  }

  if agent.subsceptible():
    b.update({
      "Shape": "circle",
      "r": 0.5,
      "Layer": 0,
      "Color": color("blue"),
    })

  if agent.recovered():
    b.update({
      "Shape": "circle",
      "r": 0.4,
      "Layer": 1,
      "Color": color("green"),
    })

  if agent.exposed():
    b.update({
      "Shape": "rect",
      "w" : .5,
      "h" : .5,
      "Layer": 2,
      "Color": color("yellow"),
    })

  if agent.infectious():
    b.update({
      "Shape": "rect",
      "w" : .5,
      "h" : .5,
      "Layer": 3,
      "Color": color("red"),
    })

  return b

if __name__ == "__main__":
  agent_dist = AgentDistribution(S=100., L=10., I=2., R=0.)
  width, height = get_dimensions(agent_dist.N)
  pixel = max(500, width * height)
  grid = CanvasGrid(agent_portrayal, width, height, pixel, pixel)

  n = ChartModule([{"Label": "n", "Color": "Black"}], data_collector_name='dc', canvas_height=300, canvas_width=pixel)
  sr = ChartModule([{"Label": "subsceptibles", "Color": color("blue")}, {"Label": "recovered", "Color": color("green")}], data_collector_name='dc', canvas_height=300, canvas_width=pixel)
  li = ChartModule([{"Label": "exposed", "Color": color("yellow")}, {"Label": "infectious", "Color": color("red")}], data_collector_name='dc', canvas_height=300, canvas_width=pixel)

  server = ModularServer(DiseaseModel, [li, grid, sr, n], "Disease Model", agent_dist, width, height)
  server.port = 9000
  server.launch()



