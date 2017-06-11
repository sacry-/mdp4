from mesa.visualization.modules import CanvasGrid
from mesa.visualization.ModularVisualization import ModularServer

from disease_model import DiseaseModel
from disease_model import AgentDistribution


def agent_portrayal(agent):
  return {
    "Shape": "circle",
    "Filled": "true",
    "Layer": 0,
    "Color": "red",
    "r": 0.5
  }

if __name__ == "__main__":
  agentDist = AgentDistribution(N=25)
  width = 7
  height = 5
  grid = CanvasGrid(agent_portrayal, width, height, 500, 500)
  server = ModularServer(DiseaseModel, [grid], "Disease Model", agentDist, width, height)
  server.port = 9000
  server.launch()