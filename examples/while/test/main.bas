10 ' Simple WHILE example that also introduces
20 ' the use of INPUT
30 answer$ = ""
40 password$ = "please"
50 WHILE answer$ <> password$
60 INPUT "What is the password: ", answer$
70 WEND
80 PRINT "That is correct, access granted"
90 END
