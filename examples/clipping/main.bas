
' SPRITE CLIPPING
'
' This example shows the sprite clipping features in BASE library
' Clipping is quite costly, so it is advised to use regular sprite
' drawing routines when possible.

chain merge "base/base.bas"

SYMBOL AFTER 256
MODE 1
INK 0,0
BORDER 3
hero.x = 40
hero.y = 100

' Coordinates in Y (lines 0-199) and X (bytes 0-79)
' Origin is set in the left bottom corner so Y goes up from 0 to 199
call scrSetClippingView(15, 30, 65, 150)

' Dot drawing coordinates always go (bottom to top) 0-639 in X and 0-400 in Y
' Conversion between dotted graphics coords and sprite coords is:
' dot.y = sp.y * 2
' dot.x = sp.x * 8
call scrDrawBox(118, 58, 528, 302)

LABEL MAIN
    IF INKEY(1) = 0 THEN hero.x = hero.x + 1
    IF INKEY(8) = 0 THEN hero.x = hero.x - 1
    IF INKEY(0) = 0 THEN hero.y = hero.y + 1
    IF INKEY(2) = 0 THEN hero.y = hero.y - 1
    ' The sprite has a blank frame so it erases itself
    RESTORE SHIP: call scrDrawSpriteClipped(hero.x, hero.y)
    FRAME
GOTO MAIN

LABEL SHIP
DATA &1206  ' W = 6 bytes, H = 18 lines (little-endian coded)
DATA &0000, &0000, &0000
DATA &0000, &0801, &0000
DATA &0000, &0801, &0000
DATA &0000, &8811, &0000
DATA &0000, &CC33, &0000
DATA &0000, &EE77, &0000
DATA &0000, &EE77, &0000
DATA &0100, &0801, &0008
DATA &0100, &0801, &0008
DATA &0300, &0909, &000C
DATA &1200, &4929, &0084
DATA &1200, &78E1, &0084
DATA &1200, &3CC3, &0084
DATA &1200, &0918, &0084
DATA &1200, &0918, &0084
DATA &0300, &0108, &000C
DATA &0100, &0000, &0008
DATA &0000, &0000, &0000
