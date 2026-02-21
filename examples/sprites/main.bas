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

MODE 1
INK 0,0
BORDER 0
LABEL MAIN
    hero.oldx = hero.x
    GOSUB MOVHERO
    GOSUB MOVENEMIES
    GOSUB DRAWHERO
    GOSUB DRAWENEMIES
GOTO MAIN

LABEL MOVHERO
    IF INKEY(8) THEN hero.x = hero.x + 4
    IF INKEY(1) THEN hero.x = hero.x - 4
    IF hero.x < 1  THEN hero.x = 1
    IF hero.x > 288 THEN hero.x = 288
RETURN

LABEL MOVENEMIES
    IF enemy.times = 10 THEN
        enemy.times = 0
        enemy.y = enemy.y + enemy.movy
        enemy.x = enemy.x + enemy.movx
    END IF
    enemy.times = enemy.times + 1
    IF enemy.y < 100 THEN enemy.movy = 2
    IF enemy.y > 200 THEN enemy.movy = -2
    IF enemy.x > 100 THEN enemy.movx = -4
    IF enemy.x < 10  THEN enemy.movx = 4
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
