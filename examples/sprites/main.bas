' This example shows how to include a library
' base.bas is located in src/lib/base
' we will use scrDrawSprite routine that is declared
' in lib/base/screen.bas

CHAIN MERGE "base/base.bas"

DIM enemy.x(5)
DIM enemy.y(5)
DIM enemy.active(5)
const HEROY = 30

MODE 1
INK 0,0
BORDER 0
GOSUB INITGAME
LABEL MAIN
    GOSUB CHECKCOLLISIONS
    GOSUB CHECKEND
    GOSUB MOVHERO
    GOSUB MOVBULLET
    GOSUB MOVENEMIES
    GOSUB DRAWBULLET
    GOSUB DRAWENEMIES
    GOSUB DRAWHERO
GOTO MAIN

LABEL INITGAME
    FOR i=0 TO 5
        enemy.x(i) = 2 + (i*8)
        enemy.y(i) = 200
        enemy.active(i) = 1
    NEXT
    enemy.times = 0
    enemy.movx  = 1
    enemy.movy  = -2

    hero.x = 35

    bullet.active = 0
    bullet.x = 0
    bullet.y = 0
    bulletsfired = 0
    CLS
RETURN

LABEL MOVHERO
    IF INKEY(1) = 0 THEN hero.x = hero.x + 1
    IF INKEY(8) = 0 THEN hero.x = hero.x - 1
    IF INKEY(47)= 0 AND bullet.active = 0 THEN
        bullet.active = 1
        bullet.x = hero.x + 2
        bullet.y = HEROY + 8
        bulletsfired = bulletsfired + 1
        GOSUB PLAYSHOOT
    END IF
    IF hero.x < 1  THEN hero.x = 1
    IF hero.x > 70 THEN hero.x = 70
RETURN

LABEL MOVENEMIES
    IF enemy.times = 5 THEN
        enemy.times = 0
        FOR i=0 to 5
            enemy.y(i) = enemy.y(i) + enemy.movy
            enemy.x(i) = enemy.x(i) + enemy.movx
        NEXT
    END IF
    enemy.times = enemy.times + 1
    IF enemy.y(0) < 100 THEN enemy.movy = 2
    IF enemy.y(0) > 196 THEN enemy.movy = -2
    IF enemy.x(0) > 30  THEN enemy.movx = -1
    IF enemy.x(0) < 1   THEN enemy.movx = 1
RETURN

LABEL MOVBULLET
    IF bullet.active THEN
        bullet.y = bullet.y + 2
        IF bullet.y > 200 THEN
            bullet.active = 0
            RESTORE CLRBULLET: call scrDrawSprite(bullet.x, bullet.y-2)
        END IF
    END IF
RETURN

LABEL CHECKCOLLISIONS
    ' Lets fine-tuning a little bit more the bounding box for the bullet
    IF bullet.active THEN
        FOR i=0 to 5
            IF enemy.active(i) THEN
                IF scrCheckRectRect(bullet.x, bullet.y, 1, 6, enemy.x(i), enemy.y(i), 8, 15) THEN
                    RESTORE CLRBULLET: call scrDrawSprite(bullet.x, bullet.y-2)
                    GOSUB PLAYEXPLOSION
                    bullet.active = 0
                    enemy.active(i) = 0
                    RESTORE EXPLOSION: call scrDrawSprite(enemy.x(i), enemy.y(i))
                    EXIT FOR
                END IF
            END IF
        NEXT
    END IF
RETURN

LABEL DRAWENEMIES
    RESTORE ENEMY
    FOR i=0 TO 5
        ' The sprite has a blank frame so it erases itself
        IF enemy.active(i) THEN call scrDrawSprite(enemy.x(i), enemy.y(i))
    NEXT
RETURN

LABEL DRAWHERO
    ' The sprite has a blank frame so it erases itself
    RESTORE HERO: call ScrDrawSprite(hero.x, HEROY)
RETURN

LABEL DRAWBULLET
    IF bullet.active THEN RESTORE BULLET: call scrDrawSprite(bullet.x, bullet.y)
RETURN

LABEL PLAYEXPLOSION
    ENV 1,11,-1,15
    ENT 1,9,49,5,9,-10,10
    SOUND 2,145,100,12,1,1,12
RETURN

LABEL PLAYSHOOT
    ENT -5,7,10,1,7,-10,1
    SOUND 1,25,20,12,0,5
RETURN

LABEL CHECKEND
    eactives = 0
    FOR i=0 to 5: eactives = eactives + enemy.active(i): NEXT
    IF eactives = 0 THEN
        LOCATE 5,10: PRINT "WELL DONE! YOU FIRED";bulletsfired;"BULLETS"
        LOCATE 7,11: PRINT "PRESS ANY KEY TO PLAY AGAIN"
        CLEAR INPUT
        WHILE INKEY$="": WEND
        GOSUB INITGAME
    END IF
RETURN

' scrDrawSprite expects the sprite to be define using
' DATA calls. Each value in DATA is a word, equivalent
' to DW in assembly. As a result, the following assembly
' line: DB &00, &00, &00, &01, &08, &00, &00, &00
' will be translated as:
'       DATA &0000,&0100,&0008,&0000
LABEL HERO
DATA &1006  ' W = 6 bytes, H = 16 lines
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

LABEL ENEMY
DATA &0F06  ' W = 6 bytes, H = 15 lines
DATA &0000, &0000, &0000
DATA &0000, &0000, &0000
DATA &0000, &0402, &0000
DATA &0000, &0402, &0000
DATA &0000, &0C02, &0000
DATA &0400, &0E07, &0002
DATA &0700, &0B0D, &000E
DATA &0000, &0F07, &0000
DATA &2200, &1F8F, &0088
DATA &3200, &3CC3, &00C0
DATA &F800, &1D8B, &00E0
DATA &7100, &0801, &00E8
DATA &6000, &0801, &00E8
DATA &0000, &0000, &0000
DATA &0000, &0000, &0000

LABEL BULLET
DATA &0802  ' W = 1 byte H = 8 lines
DATA &8010
DATA &8010
DATA &8010
DATA &8010
DATA &8010
DATA &8010
DATA &0000
DATA &0000

LABEL CLRBULLET
DATA &0602  ' W = 1 byte H = 6 lines
DATA &0000
DATA &0000
DATA &0000
DATA &0000
DATA &0000
DATA &0000

LABEL EXPLOSION
DATA &0F08
DATA &0000, &0060, &0000, &C000
DATA &0000, &0060, &0000, &C000
DATA &0000, &0000, &0801, &0000
DATA &0000, &0000, &0801, &0000
DATA &0000, &CC00, &0000, &0000
DATA &0000, &CC00, &0000, &000C
DATA &0000, &0000, &0000, &000C
DATA &0060, &0000, &0000, &0000
DATA &0060, &0000, &0000, &0000
DATA &0000, &0003, &0060, &0000
DATA &0000, &0003, &0060, &0000
DATA &0801, &0000, &0000, &8811
DATA &0801, &0000, &0300, &8811
DATA &0000, &0000, &0300, &0000
DATA &0000, &0100, &0008, &0000


