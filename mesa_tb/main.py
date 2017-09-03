import numpy as np
from math import sqrt
import numbers

from mesa.visualization.modules import CanvasGrid
from mesa.visualization.ModularVisualization import ModularServer
from mesa.visualization.modules import ChartModule

from disease_model import DiseaseModel
from agent_dist import AgentDistribution



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
      "Layer": 1,
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
      "Layer": 3,
      "Color": color("yellow"),
    })

  if agent.infectious():
    b.update({
      "Shape": "rect",
      "w" : .5,
      "h" : .5,
      "Layer": 4,
      "Color": color("red"),
    })

  if not "Layer" in b:
    print("{} - Layer not found!".format(agent))

  return b


if __name__ == "__main__":
  config = dict(S=500., L=20., I=3., R=0.)
  agent_dist = AgentDistribution(**config)
  width, height = 30, 30
  pixel = 750
  grid = CanvasGrid(agent_portrayal, width, height, pixel, pixel)

  li = ChartModule([{"Label": "exposed", "Color": color("yellow")}, {"Label": "infectious", "Color": color("red")}], data_collector_name='dc', canvas_height=300, canvas_width=500)
  n = ChartModule([{"Label": "n", "Color": "Black"}], data_collector_name='dc', canvas_height=300, canvas_width=500)
  sr = ChartModule([{"Label": "subsceptibles", "Color": color("blue")}, {"Label": "recovered", "Color": color("green")}], data_collector_name='dc', canvas_height=300, canvas_width=500)

  server = ModularServer(DiseaseModel, [grid, li, sr, n], "Disease Model", model_params={"agent_dist" : agent_dist, "width" : width, "height" : height})
  server.port = 9000
  server.launch()



