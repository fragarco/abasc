' Not the best code in the world but serves to check
' the performance of CINT and ABS functions with real
' numbers, also showing the impact of print calls.
CLS
t1 = time
a! = -15.5
for i=0 to 100
    b = cint(abs(a!)) + i
next
print b
t2 = time 
print "T1" t2-t1
print cint(1.5)
print cint(0.7)
print cint(0.3)
print cint(9999.89)
print cint(15.49)
print cint(-15.49)
print "T2" time-t2
end