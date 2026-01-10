10 ' Not the best code in the world but serves to check
20 ' the performance of CINT and ABS functions with real
30 ' numbers, also showing the impact of print calls.
40 CLS
50 ' Explicit casts
60 t1! = time
70 a! = -15.5
80 for i=0 to 100
90 b = cint(abs(a!)) + i
100 next
110 print b
120 t2! = time
130 print "T1" t2!-t1!
140 print cint(1.5)
150 print cint(0.7)
160 print cint(0.3)
170 print cint(9999.89)
180 print cint(15.49)
190 print cint(-15.49)
200 print "T2" time-t2!
210 ' Expressions and implicit casts
220 X = 0
230 E = (X + 5) / 2.2
240 print E
250 E$ = "STRING1" + "STRING2"
260 print E$
270 E! = (1 MOD 2.2) * 2
280 for i=0 to 5
290 print hex$(peek(@E!+i),2)
300 next
310 E% = 5.2 \ 2.2
320 print E%
330 E = "STRING1" >= "STRING"
340 print E
350 E = (1 AND 1.2) OR 1.5
360 print E
370 end
