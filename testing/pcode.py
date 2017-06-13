
STATES = ["A"]

class Abc(object):
  """docstring for Abc"""
  s = ["a", "b"]
  def __init__(self, arg):
    self.arg = arg


a = Abc(1)
print(a.s)
a.s = None
print(a.s)
print(Abc.s)