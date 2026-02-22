' This example shows how to include a library
' base.bas is located in src/lib/base
' we will use scrDrawSprite routine that is declared
' in lib/base/screen.bas

CHAIN MERGE "base/base.bas"

enemy.x = 10
enemy.y = 200
enemy.times = 0
enemy.movx  = 4
enemy.movy  = -2

hero.x = 140
const HEROY = 30

bullet.active = 0
bullet.x = 0
bullet.y = 0

MODE 1
INK 0,0
BORDER 0
LABEL MAIN
    GOSUB MOVHERO
    GOSUB MOVBULLET
    GOSUB MOVENEMIES
    
    GOSUB DRAWBULLET
    GOSUB DRAWENEMIES
    GOSUB DRAWHERO
GOTO MAIN

LABEL MOVHERO
    IF INKEY(1) = 0 THEN hero.x = hero.x + 4
    IF INKEY(8) = 0 THEN hero.x = hero.x - 4
    IF INKEY(47)= 0 AND bullet.active = 0 THEN
        bullet.active = 1
        bullet.x = hero.x+ 14
        bullet.y = HEROY + 8
        GOSUB PLAYSHOOT
    END IF
    IF hero.x < 1  THEN hero.x = 1
    IF hero.x > 288 THEN hero.x = 288
RETURN

LABEL MOVENEMIES
    IF enemy.times = 5 THEN
        enemy.times = 0
        enemy.y = enemy.y + enemy.movy
        enemy.x = enemy.x + enemy.movx
    END IF
    enemy.times = enemy.times + 1
    IF enemy.y < 100 THEN enemy.movy = 2
    IF enemy.y > 196 THEN enemy.movy = -2
    IF enemy.x > 100 THEN enemy.movx = -4
    IF enemy.x < 10  THEN enemy.movx = 4
RETURN

LABEL MOVBULLET
    IF bullet.active THEN
        bullet.y = bullet.y + 2
        IF bullet.y > 200 THEN
            bullet.active = 0
            RESTORE CLRBULLET: call scrDrawSprite(bullet.x, bullet.y-2)
            GOSUB PLAYEXPLOSION
        END IF
    END IF
RETURN


LABEL DRAWENEMIES
    RESTORE ENEMY: xoffset = enemy.x
    FOR i=0 TO 5
        ' The sprite has a blank frame so it erases itself
        call scrDrawSprite(xoffset, enemy.y)
        xoffset = xoffset + 30
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

' scrDrawSprite expects the sprite to be define using
' DATA calls. Each value in DATA is a word, equivalent
' to DW in assembly. As a result, the following assembly
' line: DB &00, &00, &00, &01, &08, &00, &00, &00
' will be translated as:
'       DATA &0000,&0100,&0008,&0000
LABEL HERO
DATA &1008  ' W = 8 bytes, H = 16 lines
DATA &0000, &0100, &0008, &0000
DATA &0000, &0100, &0008, &0000
DATA &0000, &1100, &0088, &0000
DATA &0000, &3300, &00CC, &0000
DATA &0000, &7700, &00EE, &0000
DATA &0000, &7700, &00EE, &0000
DATA &0000, &0101, &0808, &0000
DATA &0000, &0101, &0808, &0000
DATA &0000, &0903, &0C09, &0000
DATA &0000, &2912, &8449, &0000
DATA &0000, &E112, &8478, &0000
DATA &0000, &C312, &843C, &0000
DATA &0000, &1812, &8409, &0000
DATA &0000, &1812, &8409, &0000
DATA &0000, &0803, &0C01, &0000
DATA &0000, &0001, &0800, &0000

LABEL ENEMY
DATA &0F08  ' W = 8 bytes, H = 15 lines
DATA &0000, &0000, &0000, &0000
DATA &0000, &0000, &0000, &0000
DATA &0000, &0200, &0004, &0000
DATA &0000, &0200, &0004, &0000
DATA &0000, &0200, &000C, &0000
DATA &0000, &0704, &020E, &0000
DATA &0000, &0D07, &0E0B, &0000
DATA &0000, &0700, &000F, &0000
DATA &0000, &8F22, &881F, &0000
DATA &0000, &C332, &C03C, &0000
DATA &0000, &8BF8, &E01D, &0000
DATA &0000, &0171, &E808, &0000
DATA &0000, &0160, &E808, &0000
DATA &0000, &0000, &0000, &0000
DATA &0000, &0000, &0000, &0000

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

