' RECORD EXAMPLE
' Records where introduced in Locomotive BASIC 2.
' Basically they are just alias to access portions
' of a memory block reserved as a string so you
' can store different kind of data and simulate a
' struct data type
RECORD person; name$ FIXED 10, age, birth
DIM records$(5) FIXED 14


CLS
FOR I=0 TO 5
    READ records$(i).person.name$, records$(i).person.age, records$(i).person.birth
    PRINT "Customer:", records$(i).person.name$
    PRINT "Age:", records$(i).person.age
    PRINT "Born in:", records$(i).person.birth
NEXT
END

DATA "Xavier", 49, 1976
DATA "Ross", 47, 1978
DATA "Gada", 12, 2013
DATA "Anabel", 51, 1974
DATA "Rachel", 45, 1980
DATA "Elvira", 20, 2005
