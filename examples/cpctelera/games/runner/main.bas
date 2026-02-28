' RUDOLPHS RACE
' Based on the runner game created by:
' Copyright (c) 2019 Héctor Linares Pérez (Twitter @Hec_Linares) [ByteRealms, Cheesetea]
' Copyright (c) 2019 Francisco J. Gallego-Durán (Twitter @FranGallegoBR) [ByteRealms, Cheesetea]
' Developed under MIT license during the Christmas Special 2025 episode of CPC GameDec Challenge
' The episode can be seen here:
'      https://www.youtube.com/watch?v=bOR93yef3po
'
' This version was adapted by Javier "Dwayne Hicks" Garcia

chain merge "cpctelera/cpctelera.bas"
chain merge "base/base.bas"

const GRDY = 170
const PLAYERY = 170 - 16
const PLAYERX = 10
const SCREEN.W = 80
const SCREEN.H = 200
const MAXOBSTACLES = 2
const OBSSTART = 75

pvmem = 0
player.x = PLAYERX
player.y = PLAYERY
player.oldy = PLAYERY
player.speed = 0
player.jumping = 0
player.sp = @LABEL("renosp")

DIM obstacle.x(MAXOBSTACLES)
DIM obstacle.y(MAXOBSTACLES)
DIM obstacle.oldx(MAXOBSTACLES)
DIM obstacle.speed(MAXOBSTACLES)
DIM obstacle.active(MAXOBSTACLES)
obstacle.sp = @LABEL("arbolsp")

' jump sound
ENV 2,10,-1,10
ENT 2,5,-1,4,5,1,4,5,-1,4,5,1,4
' hit sound
ENT 3,100,5,3

gosub gameIntro
gosub initGame
label MAIN
    gosub resetGame
    while alive
        gosub update
        gosub render
    wend
    gosub endGame
    goto MAIN
end

label gameIntro
    mode 1
    call txtPrintBig("RUDOLPH'S RACE", 6, 2, 1, 3)
    locate 2,8
    print "It's Christmas Eve and Rudolph is late"
    print "for his annual appointment! Help him  "
    print "cross the forest so he can fulfill his"
    print "important mission. Use the spacebar to"
    print "make Rudolph jump."
    clear input
    locate 12,20: print "PRESS S TO START"
    while INKEY$<>"s": wend
return

label initGame
    mode 0
    INK 0,1: INK 1,12: INK 2,9: INK 3,24: INK 4,6: INK 5,17: INK 6,26
    INK 7,9,18
    INK 8,18,9
    border 1
return

label resetGame
    player.x = PLAYERX
    player.y = PLAYERY
    plater.oldy = player.y
    player.speed = 0
    player.jumping = 0
    for i=0 to MAXOBSTACLES:
        obstacle.x(i) = OBSSTART
        obstacle.oldx(i) = OBSSTART
        obstacle.y(i) = PLAYERY
        obstacle.speed(i) = -1
        obstacle.active(i) = 0
    next
    obstacle.active(0) = 1
    CLS
    gosub renderGround
    alive = 1
    score = 0
    pen 3: locate 1,1: print "SCORE:";score
return

label endGame
    pen 3
    locate 2,10: PRINT "THAT TREE HIT YOU!"
    locate 4,11: PRINT "PRESS S TO START"
    clear input
    while alive = 0
        call cpctScanKeyboard()
        if cpctIsKeyPressed(KEY.S) then alive = 1
    wend
return

label update
    gosub updatePlayer
    gosub updateObstacles
    gosub checkCollisions
return

label updatePlayer
    call cpctScanKeyboard()
    if cpctIsKeyPressed(KEY.SPACE) and player.jumping = 0 then
        player.jumping = 1
        player.speed = -12
        SOUND 1,239,50,15,2,2
    end if
    player.oldy = player.y
    player.y = player.y + player.speed
    if player.y < PLAYERY then
        player.speed = player.speed + 1
    else
        player.y = PLAYERY
        player.jumping = 0
        player.speed = 0
    end if
return

label updateObstacles
    for i=0 to MAXOBSTACLES
        if obstacle.active(i) then
            currentx = obstacle.x(i)
            obstacle.oldx(i) = currentx
            obstacle.x(i) = currentx + obstacle.speed(i)
            if obstacle.x(i) < 4 then
                obstacle.x(i) = OBSSTART: score=score + 1
                pen 3: locate 1,1: print "SCORE:";score
            end if
        end if
    next
    if score > 10 and obstacle.x(0) < 40 then obstacle.active(1) = 1
    if score > 20 and obstacle.x(1) < 50 then obstacle.active(2) = 1
return

label checkCollisions
    ' remember: x is in bytes
    for i=0 to MAXOBSTACLES
        if obstacle.active(i) then
            if ABS(player.x - obstacle.x(i)) < 4 and (obstacle.y(i) - player.y < 14) then
                SOUND 2,142,100,15,0,3
                alive = 0
                exit for
            end if
        end if
    next
return

label render
    FRAME
    gosub renderPlayer
    gosub renderObstacle
return

label renderGround
    pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, 0, GRDY)
    ' Amstrad CPC has 80 bytes of screen width
    ' cpctDrawSolidBox has a limitation of 63 bytes width max
    ' so let's draw two boxes
    colorpatter = cpctpx2byteM0(7,8)
    call cpctDrawSolidBox(pvmem, colorpatter, 40, 8)
    call cpctDrawSolidBox(pvmem+40, colorpatter, 40, 8)    
return

label renderPlayer
    if player.y <> player.oldy then
        pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, player.x, player.oldy)
        call cpctDrawSolidBox(pvmem,0, 4, 16)
    end if
    pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, player.x, player.y)
    call cpctDrawSprite(player.sp, pvmem, 4, 16)
return

label renderObstacle
    for i=0 to MAXOBSTACLES
        if obstacle.active(i) then
            if obstacle.x(i) <> obstacle.oldx(i) then
                pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, obstacle.oldx(i), obstacle.y(i))
                call cpctDrawSolidBox(pvmem,0, 4, 16)
            end if
            pvmem = cpctGetScreenPtr(CPCT.VMEMSTART, obstacle.x(i), obstacle.y(i))
            call cpctDrawSprite(obstacle.sp, pvmem, 4, 16)
        end if
    next
return

' sprites_hwpal:
asm "palette: db 0x4, 0x1E, 0x16, 0x0A, 0x0C, 0x0F, 0x0B"

asm "renosp:"
asm "db &00, &00, &00, &00"
asm "db &00, &00, &00, &00"
asm "db &40, &40, &40, &40"
asm "db &40, &40, &40, &40"
asm "db &40, &C0, &C0, &C0"
asm "db &00, &C0, &C0, &28"
asm "db &00, &40, &C0, &90"
asm "db &00, &00, &C0, &28"
asm "db &C0, &00, &40, &80"
asm "db &40, &C0, &C0, &80"
asm "db &00, &C0, &C0, &00"
asm "db &40, &C0, &C0, &80"
asm "db &40, &40, &40, &40"
asm "db &40, &40, &40, &40"
asm "db &40, &40, &40, &40"
asm "db &40, &40, &40, &40"

asm "arbolsp:"
asm "db &00, &44, &88, &00"
asm "db &00, &CC, &CC, &00"
asm "db &00, &CC, &CC, &00"
asm "db &00, &44, &88, &00"
asm "db &00, &04, &08, &00"
asm "db &00, &0C, &0C, &00"
asm "db &04, &18, &0C, &08"
asm "db &00, &A4, &18, &00"
asm "db &04, &18, &0C, &08"
asm "db &0C, &A4, &18, &0C"
asm "db &00, &18, &0C, &00"
asm "db &04, &A4, &18, &08"
asm "db &0C, &0C, &0C, &0C"
asm "db &00, &40, &80, &00"
asm "db &00, &40, &80, &00"
asm "db &00, &40, &80, &00"
