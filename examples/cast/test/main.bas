10 ' Not the best code in the world but serves to check
20 ' the performance of CINT and ABS functions with real
30 ' numbers, also showing the impact of print calls.
40 CLS
50 ' cint of an expression (call to another func)
60 t1! = TIME
70 a! = -115.5
80 b = cint(abs(a!)) + i
90 print b
100 t2! = TIME
110 print "T1: " t2!-t1!
120 ' check optimization and regular calls to CINT
130 num!=1.5
140 print cint(1.5), cint(num!)
150 num!=0.7
160 print cint(0.7), cint(num!)
170 num!=0.3
180 print cint(0.3), cint(num!)
190 num!=9999.89
200 print cint(9999.89), cint(num!)
210 num!=15.49
220 print cint(15.49), cint(num!)
230 num!=-15.49
240 print cint(-15.49), cint(num!)
250 X = 0
260 E = (X + 5) / 2.2
270 print E
280 E$ = "STR1" + "STR2"
290 F$ = "STR1"
300 G$ = F$ + "STR2"
310 print E$,G$
320 t1!=TIME
330 print "T2: " t1!-t2!
340 ' Expressions with implicit casts
350 E! = (1 MOD 2.2) * 2
360 for i=0 to 4
370 print hex$(peek(@E!+i),2);" ";
380 next
390 print
400 num!=2.2
410 E! = (1 MOD num!) * 2
420 for i=0 to 4
430 print hex$(peek(@E!+i),2);" ";
440 next
450 print
460 num!=2.2
470 E% = 5.2 \ 2.2
480 F% = 5.2 \ num!
490 print E%,F%
500 E = "STRING1" >= "STRING"
510 A$ = "STRING1"
520 F = A$ >= "STRING"
530 print E,F
540 num! = 1.2
550 E = (1 AND 1.2) OR 1.5
560 A = (1 AND num!) OR 1.5
570 print E,A
580 print "T3: " TIME-t1!
590 end
