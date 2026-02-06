'-----------------------------LICENSE NOTICE------------------------------------
'  This file is part of CPCtelera: An Amstrad CPC Game Engine
'  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
'
'  This program is free software: you can redistribute it and/or modify
'  it under the terms of the GNU Lesser General Public License as published by
'  the Free Software Foundation, either version 3 of the License, or
'  (at your option) any later version.
'
'  This program is distributed in the hope that it will be useful,
'  but WITHOUT ANY WARRANTY without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU Lesser General Public License for more details.
'
'  You should have received a copy of the GNU Lesser General Public License
'  along with this program.  If not, see <http:'www.gnu.org/licenses/>.
'------------------------------------------------------------------------------

chain merge "cpctelera/cpctelera.bas"

'
' Defined type to know the status of a Key 
'    Key is either Pressed / Released, and K_NOEVENT is used to
'    report that a key is in the same status as in previous checks
'    (Continues pressed or continues released)
'
const KS.NOEVENT  = 0
const KS.RELEASED = 1
const KS.PRESSED  = 2

''''''''''''''''''''''''''''''''''''
' Checks if a Key has changed from pressed to released or viceversa
' If it has changed, that is considered and event and the concrete
' event is returned. If it is in its previous status, nothing is done
' and KS.NOEVENT is returned
'
function checkKeyEvent(keyID, stindex, keystatus[2])
   shared KS.NOEVENT, KS.PRESSED, KS.RELEASED
   newstatus = KS.NOEVENT   ' Hold the new status of the key (pressed / released)

   ' Check the new status of the key and save it into newstatus
   if cpctIsKeyPressed(keyID) then
      newstatus = KS.PRESSED   ' Key is now pressed
   else
      newstatus = KS.RELEASED  ' Key is now released
   end if
   ' Check if newstatus is same or different than previous one
   ' If it is different, report the event
   if newstatus = keystatus(stindex) then
      checkKeyEvent = KS.NOEVENT ' Same key status, report NO EVENT
   else
      keystatus(stindex) = newstatus
      checkKeyEvent = newstatus ' Status has changed, return the new status
   end if
end function

''''''''''''''''''''''''''''''''''''
' MAIN: Arkos Tracker Music Example
'    Keys:
'       * SPACE - Start / Stop Music
'       *   1   - Play a sound effect on Channel A
'       *   2   - Play a sound effect on Channel C
'
label MAIN
   DIM keyst(2)                 ' Status of the 3 Keys for this example (Space, 1, 2)
   keyst(0) = KS.RELEASED       ' All 3 keys are considered to be released at the start of the program 
   keyst(1) = KS.RELEASED            
   keyst(2) = KS.RELEASED
   playing   = 1               ' Flag to know if music is playing or not
   color     = 1               ' Color to draw charactes (normal / inverse)
   pvideomem = CPCT.VMEMSTART  ' Pointer to video memory where next character will be drawn
   songaddr  = @LABEL("molusk_song_address")

   ' Initialize CPC
   call cpctRemoveInterruptHandler() ' Disable firmware to prevent interaction
   call cpctSetVideoMode(2)          ' Set Mode 2 (64&200, 2 colours)
   call cpctSetDrawCharM2(1, 0)      ' Set Initial colours for drawCharM2 (Foreground/Background)

   ' Initialize the song to be played
   call cpctakpMusicInit(songaddr)    ' Initialize the music
   call cpctakpSFXInit(songaddr)      ' Initialize instruments to be used for SFX (Same as music song)

   while 1
      ' We have to call the play function 50 times per second (because the song is 
      ' designed at 50Hz). We only have to wait for VSYNC and call the play function
      ' when the song is not stopped (still playing)
      call cpctWaitVSYNC()

      ' Check if the music is playing. When it is, do all the things the music
      ' requires to be done every 1/50 secs.
      if playing then
         call cpctakpMusicPlay()   ' Play next music 1/50 step.
         ' Write a new number to the screen to see something while playing. 
         ' The number will be 0 when music is playing, and 1 when it finishes.
         '  -> If some SFX is playing write the channel where it is playing
         
         ' Check if there is an instrument plaing on channel A
         if cpctakpSFXGetInstrument(AY.CHANNELA) then
            call cpctDrawCharM2(pvideomem, asc("A")) ' Write an 'A' because channel A is playing
         else
            ' Check if there is an instrument plaing on channel C
            if cpctakpSFXGetInstrument(AY.CHANNELC) then
               call cpctDrawCharM2(pvideomem, asc("C")) ' Write an 'C' because channel C is playing 
            else
               ' No SFX is playing on Channels A or C, write the number of times
               ' this song has looped.
               call cpctDrawCharM2(pvideomem, asc("0") + cpctakpSongLoopTimes())
            end if
         end if
         ' Point to the start of the next character in video memory
         pvideomem = pvideomem + 1
         if pvideomem >= &C7D0 then
            pvideomem = CPCT.VMEMSTART ' When we reach the end of the screen, we return..
            color = color XOR 1        ' .. to the start, and change the colour
            call cpctSetDrawCharM2(color, color XOR 1) ' Set new colour pair for drawCharM2 (inverted from previous one)
         end if

         ' Check if music has already ended (when looptimes is > 0)
         if cpctakpSongLoopTimes() > 0 then call cpctakpMusicInit(songaddr) ' Song has ended, start it again and set loop to 0
      end if

      ' Check keyboard to let the user play/stop the song with de Space Bar
      ' and reproduce some sound effects with keys 1 and 0
      call cpctScanKeyboardf()

      ' When Space is released, stop / continue music
      if checkKeyEvent(KEY.SPACE, 0, keyst[]) = KS.RELEASED then
         ' Only stop it when it was playing previously
         ' No need to call "play" again when continuing, as the
         ' change in "playing" status will make the program call "play"
         ' again from the next cycle on
         if playing then call cpctakpStop()
         
         ' Change it from playing to not playing and viceversa (0 to 1, 1 to 0)
         playing = playing XOR 1
      else
         ' Check if Key 0 has been released to reproduce a Sound effect on channel A
         if checkKeyEvent(KEY.0, 1, keyst[]) = KS.RELEASED then
            call cpctakpSFXPlay(13, 15, 36, 20, 0, AY.CHANNELA)
         else
            ' Check if Key 1 has been released to reproduce a Sound effect on channel C
            if checkKeyEvent(KEY.1, 2, keyst[]) = KS.RELEASED then 
               call cpctakpSFXPlay(3, 15, 60, 0, 40, AY.CHANNELC)
            end if
         end if
      end if
   wend
end

' CAUTION! the molusk song uses absolute memory address.
' the molush.asm includes an ORG directive to set that address
' it is always a good idea to check the .LST file to verify that
' everything fits into place and there are not memory overwrites.
asm "read 'music/molusk.asm'"
