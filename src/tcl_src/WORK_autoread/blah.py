import copy
my__d = {}
my__d[0] = 0
my__d[1] = 1
my__d[2] = 2

my__d_2 = copy.copy(my__d)
print my__d_2
my__d_2[1] = 10
print my__d_2
print my__d
