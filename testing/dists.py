import matplotlib.pyplot as plt
import numpy as np
import scipy.special as sps




def age_dist(mean=2., std=9.5, samples=100000):
  s = np.random.gamma(mean, std, samples)
  print(np.random.choice(s)

age_dist()




# def agedistro(turn,end,size):
#     pass
#     totarea = turn + (end-turn)/2  # e.g. 50 + (90-50)/2
#     areauptoturn = turn             # say 50
#     areasloped = (end-turn)/2     # (90-50)/2
#     size1= int(size*areauptoturn/totarea)
#     size2= size- size1
#     s1 = np.random.uniform(low=0,high=turn,size= size1)  # (low=0.0, high=1.0, size=None)
#     s2 = np.random.triangular(left=turn,mode=turn,right=end,size=size2) #(left, mode, right, size=None)
#             # mode : scalar-  the value where the peak of the distribution occurs.
#             #The value should fulfill the condition left <= mode <= right.
#     s3= np.concatenate((s1,s2)) # don't use add , it will add the numbers piecewise
#     return s3

# s3=agedistro(turn=50,end=90,size=1000000)
# p.hist(s3,bins=50)
# p.show()