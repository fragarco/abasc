' Not the best code in the world but serves to check
' the performance of CINT and ABS functions with real
' numbers, also showing the impact of print calls.
CLS
' cint of an expression (call to another func)
t1! = TIME
a! = -115.5
b = cint(abs(a!)) + i
print b
t2! = TIME 
print "T1: " t2!-t1!

' check optimization and regular calls to CINT
num!=1.5
print cint(1.5), cint(num!)
num!=0.7
print cint(0.7), cint(num!)
num!=0.3
print cint(0.3), cint(num!)
num!=9999.89
print cint(9999.89), cint(num!)
num!=15.49
print cint(15.49), cint(num!)
num!=-15.49
print cint(-15.49), cint(num!)
X = 0
E = (X + 5) / 2.2
print E
E$ = "STR1" + "STR2"
F$ = "STR1"
G$ = F$ + "STR2"
print E$,G$
t1!=TIME
print "T2: " t1!-t2!

' Expressions with implicit casts
E! = (1 MOD 2.2) * 2
for i=0 to 4
    print hex$(peek(@E!+i),2);" ";
next
print
num!=2.2
E! = (1 MOD num!) * 2
for i=0 to 4
    print hex$(peek(@E!+i),2);" ";
next
print

num!=2.2
E% = 5.2 \ 2.2
F% = 5.2 \ num!
print E%,F%

E = "STRING1" >= "STRING"
A$ = "STRING"
F = A$ >= "STRING"
print E,F

num! = 1.2
E = (1 AND 1.2) OR 1.5
A = (1 AND num!) OR 1.5
print E,A

print "T3: " TIME-t1!
end