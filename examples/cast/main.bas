' Not the best code in the world but serves to check
' the performance of CINT and ABS functions with real
' numbers, also showing the impact of print calls.
CLS
' Explicit casts
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
' Expressions and implicit casts
X = 0
E = (X + 5) / 2.2
print E
E$ = "STRING1" + "STRING2"
print E$
E! = (1 MOD 2.2) * 2
for i=0 to 5
    print hex$(peek(@E!+i),2)
next
E% = 5.2 \ 2.2
print E%
E = "STRING1" >= "STRING"
print E
E = (1 AND 1.2) OR 1.5 
print E
end