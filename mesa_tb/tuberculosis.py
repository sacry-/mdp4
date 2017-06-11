from logger import Logger


logger = Logger(__name__).getLogger()


# S - Subsceptible to TB
S = "S"
# L - Latently exposed (not infectious)
L = "L"
# I - Infected in an active state
I = "I"
# R - Recovered means all that live having had TB
R = "R"

STATES = [ S, L, I, R ]
INFECTED = [L, I]

def current_state(state, vaccinated=False, treatment=True, hiv=False, immune_diseases=False, age=30):
  if state == S:
    SState(vaccinated, hiv, immune_diseases, age)

  elif state == L:
    LState(treatment, hiv, immune_diseases, age)

  elif state == I:
    IState(treatment, hiv, immune_diseases, age)

  elif state == R:
    RState(treatment, age)

  else:
    raise "'state={}' must be in {}!".format(state, ", ".join(STATES))

def infected(state):
  return state in [L, I]

# Private somehow...
def SState(vaccinated, hiv, immune_diseases, age):
  pass

def LState(treatment, hiv, immune_diseases, age):
  pass

def IState(treatment, hiv, immune_diseases, age):
  pass

def RState(treatment, age):
  pass

