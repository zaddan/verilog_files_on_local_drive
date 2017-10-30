def foo():
    d = {}
    d[0] = 1
    d[1] = 3
    return (d,2)

a,\
b = foo()
print a
print "ok"
print b
