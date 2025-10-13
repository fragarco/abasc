10 ' Not the best code in the world but serves to check
20 ' the performance of CINT and ABS functions with real
30 ' numbers, also showing the impact of print calls.
40 CLS
50 t1 = time
60 a! = -15.5
70 for i=0 to 100
80 b = cint(abs(a!)) + i
90 next
100 print b
110 t2 = time
120 print "T1" t2-t1
130 print cint(1.5)
140 print cint(0.7)
150 print cint(0.3)
160 print cint(9999.89)
170 print cint(15.49)
180 print cint(-15.49)
190 print "T2" time-t2
200 end
