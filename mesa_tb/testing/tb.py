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

TREATMENT_PROB = 0
HIV_PROB = 0
ID_PROB = 0

MAX_AGE = 100
AGE_PROP = 0.1

def get_state(state, vaccinated=False, treatment=True, hiv=False, immune_diseases=False, age=30):
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

def SState(vaccinated, hiv, immune_diseases, age):
  print("S")

def LState(treatment, hiv, immune_diseases, age):
  print("S")

def IState(treatment, hiv, immune_diseases, age):
  print("S")

def RState(treatment, age):
  print("S")

def infected(state):
  return state in [L, I]



state = get_state("S")
print(state)
print(age_chance(1000, 30))
