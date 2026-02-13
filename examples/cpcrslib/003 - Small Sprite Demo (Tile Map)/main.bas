' Code adapted to ABASM syntax by Javier "Dwayne Hicks" Garcia
' Based on CPCRSLIB:
' Copyright (c) 2008-2015 Raúl Simarro <artaburu@hotmail.com>
'
' Permission is hereby granted, free of charge, to any person obtaining a copy of
' this software and associated documentation files (the "Software"), to deal in the
' Software without restriction, including without limitation the rights to use, copy,
' modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
' and to permit persons to whom the Software is furnished to do so, subject to the
' following conditions:
'
' The above copyright notice and this permission notice shall be included in all copies
' or substantial portions of the Software.
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
' INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
' PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
' FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
' OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.

chain merge "cpcrslib/cpcrslib.bas"
chain merge "base/bytepos.bas"

' addresses to our sprites data included through sprites.asm
SPRITE1 = @LABEL("_sp_1")
SPRITE2 = @LABEL("_sp_2")

' cpcrslib defines a basic structure to manage sprites
' that structure is defined as an Abasc RECORD
DIM sprites$(2) FIXED RSPRITE.SIZE  

sub Init
    MODE 0
    ' set sprites palette
    INK 0,0: INK 1,13: INK 2,1: INK 3,6
    INK 4,26: INK 5,24: INK 6,15: INK 7,8
    INK 8,10: INK 9,22: INK 10,14: INK 11,3
    INK 12,18: INK 13,4: INK 14,11: INK 15,25
    BORDER 0
    call rsSetInkGphStrM0(0, 0)
end sub

sub ShowCollision
    INK 16,1
    call rsPause(200)
    INK 16,9
end sub

sub DrawTilemap
    ' Set the tiles of the map. In this example, the tile map is 32x16 tile
    ' Tile Map configuration file: TileMapConf.asm
    y = 0
    for x=0 to 31: call rsSetTile(x, y, 1): next
    for y=1 to 14
        for x=0 to 31: call rsSetTile(x, y, 0): next
    next
    y = 15
    for x=0 to 31: call rsSetTile(x, y, 2): next
end sub

sub PrintCredits
    call rsPrintGphStrXYM0("SMALL;SPRITE;DEMO", 9*2+3, 20*8)
    call rsPrintGphStrXYM0("SDCC;;;CPCRSLIB", 10*2+3, 21*8)
    call rsPrintGphStrXYM0("BY;ARTABURU;2015", 10*2+2, 22*8)
    call rsPrintGphStrXYM0("ESPSOFT<AMSTRAD<ES", 10*2+3-3, 24*8)
end sub

label MAIN
    call Init()
    call rsDisableFirmware()
    ' All the sprite values are initilized
    sprites$(0).rssp.sp0 = SPRITE1
    sprites$(0).rssp.sp1 = SPRITE1
    sprites$(0).rssp.opos = BytePosSet(50, 70)
    sprites$(0).rssp.cpos = BytePosSet(50, 70)
    sprites$(0).rssp.movedir = BytePosSet(3, 0)
    call rsSuperbufferAddress(@sprites$(0)) ' First time it's important to do this

    sprites$(1).rssp.sp0 = SPRITE2
    sprites$(1).rssp.sp1 = SPRITE2
    sprites$(1).rssp.opos = BytePosSet(50, 106)
    sprites$(1).rssp.cpos = BytePosSet(50, 106)
    sprites$(1).rssp.movedir = BytePosSet(3, 1)
    call rsSuperbufferAddress(@sprites$(1))

    sprites$(2).rssp.sp0 = SPRITE2
    sprites$(2).rssp.sp1 = SPRITE2
    sprites$(2).rssp.opos = BytePosSet(20, 100)
    sprites$(2).rssp.cpos = BytePosSet(20, 100)
    sprites$(2).rssp.movedir = BytePosSet(3, 2)
    call rsSuperbufferAddress(@sprites$(2))

    call DrawTilemap()      ' Drawing the tile map
    call rsShowTileMap()    ' Show entire tile map in the screen
    call PrintCredits()
    call rsSetTile(0, 1, 2)
    call rsShowTileMap()    ' Show entire tile map in the screen
    while 1 
        ' We use by default the cursor keys to move the character sprite
        ' 0: cursor right
        ' 1: cursor left
        ' 2: cursor up
        ' 3: cursor down
        ' For example., if key 0 is pressed, and the sprite is inside tilemap, then
        ' the sprite is moved one byte to the right:
        if rsTestKey(0) then
            posx = BytePosGetX(sprites$(0).rssp.cpos)
            posy = BytePosGetY(sprites$(0).rssp.cpos)
            if posx < 60 then sprites$(0).rssp.cpos = BytePosSet(posx+1, posy)
        end if
        if rsTestKey(1) then
            posx = BytePosGetX(sprites$(0).rssp.cpos)
            posy = BytePosGetY(sprites$(0).rssp.cpos)
            if posx > 0 then sprites$(0).rssp.cpos = BytePosSet(posx-1, posy)
        end if
        if rsTestKey(2) then
            posx = BytePosGetX(sprites$(0).rssp.cpos)
            posy = BytePosGetY(sprites$(0).rssp.cpos)
            if posy > 0 then sprites$(0).rssp.posy = BytePosSet(posx, posy-2)
        end if
        if rsTestKey(3) then
            posx = BytePosGetX(sprites$(0).rssp.cpos)
            posy = BytePosGetY(sprites$(0).rssp.cpos)
            if posy < 112 then sprites$(0).rssp.posy = BytePosSet(posx, posy+2)
        end if

        ' The enemy sprites are automatically moved
        posx = BytePosGetX(sprites$(1).rssp.cpos)
        posy = BytePosGetY(sprites$(1).rssp.cpos)
        diry = BytePosGetY(sprites$(1).rssp.movdir)
        if diry = 0 then ' 0 = left, 1 = right
            if xpos > 0 then
                sprites$(1).rssp.cpos = BytePosSet(posx-1, posy)
            else
                sprites$(1).rssp.movdir = BytePosSet(3, 1)
            end if
        end if
        if diry = 1 then ' 0 = left, 1 = right
            if posx < 60 then
                sprites$(1).rssp.cpos = BytePosSet(posx+1, posy)
            else
                sprites$(1).rssp.movdir = BytePosSet(3, 0)
            end if
        end if

        posx = BytePosGetX(sprites$(2).rssp.cpos)
        posy = BytePosGetY(sprites$(2).rssp.cpos)
        diry = BytePosGetY(sprites$(2).rssp.movdir)
        if diry = 2 then   ' 2 = up, 3 = down
            if ypos > 0 then 
                sprites$(2).rssp.cpos = BytePosSet(posx, posy-2)
            else
                sprites$(2).rssp.movdir = BytePosSet(3, 3)
            end if
        end if
        if diry = 3 then  ' 2 = up, 3 = down
            if posy < 106 then
                sprites$(2).rssp.cpos = BytePosSet(posx, posy+2)
            else
                sprites$(2).rssp.movdir = BytePosSet(3, 2)
            end if
        end if

        call rsResetTouchedTiles()	' Clear touched tile table

        ' Sprite phase 1
        ' Search the tiles where is and was the sprite
        call rsPutSpTileMap(sprites$(0))
        call rsPutSpTileMap(sprites$(1))
        call rsPutSpTileMap(sprites$(2))

        call rsUpdScr()	' Update the screen to new situation (show the touched tiles)

        ' Sprite phase 2
        call rsPutMaskSpTileMap2b(sprites$(0))
        call rsPutMaskSpTileMap2b(sprites$(1))
        call rsPutMaskSpTileMap2b(sprites$(2))
        call rsShowTileMap2() ' Show the touched tiles-> show the new sprite situatuion

        ' Test if there is collision between sprite00 and sprite01
        if rsCollideSp(sprites$(0), sprites$(1)) then call ShowCollision()
        if rsCollideSp(sprites$(0), sprites$(2)) then call ShowCollision()
    wend
end

asm "read 'assets/sprites.asm'"
asm "read 'assets/tilemap_config.asm'"
