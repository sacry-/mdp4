import logging
import os


class Logger():

  def __init__(self, name, propagate=False):
    self.name = name
    self.logger = logging.getLogger(self.name)
    self.propagate = propagate

  def getLogger(self):
    self.logger = logging.getLogger(self.name)
    handler = logging.FileHandler("{}/{}.log".format("./logs", self.name))
    handler.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s', "%m-%d %H:%M:%S")
    handler.setFormatter(formatter)
    self.logger.addHandler(handler)
    self.logger.setLevel(logging.INFO)
    self.logger.propagate = self.propagate
    return self.logger


if __name__ == "__main__":
  pass