10 t! = time
20 A$ = "apples"
30 V  = 5
40 P! = 1.25
50 for n=0 to 100
60	locate 1,1: print "......"
61	print using ">####<";125
62	print dec$(125, ">####<")
63	print using ">###.##<";12.5
64	print dec$(12.5, ">###.##<")
65	print "......"
66	print using "I bought # \      \ at ##.### euros"; V,A$,P!
70 next
80 print time - t!