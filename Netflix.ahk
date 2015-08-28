; Open the Netflix app
Run explorer.exe netflix:

; After 250ms, click the Fullscreen button
sleep 250
Click 1727, 32

; The following section is the configuration section. Most of it (and most of the
; mouse control script) was taken from here: http://ahkscript.org/docs/scripts/JoystickMouse.htm

; Increase the following value to make the mouse cursor move faster:
JoyMultiplier = 0.30

; Change to adjust the rate the volume changes. Speed does not scale with
; the distance joystick is from center.
SetTimer, WatchVolume, 10

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 15

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

; Change these values to change the various control buttons. 
; Use the Joystick Test Script to find out your joystick's numbers more easily.
ButtonClick = 1
ButtonBack = 2
ButtonPlay = 3
ButtonSearch = 4

; If your joystick has a POV control, you can use it as a mouse wheel.  The
; following value is the number of milliseconds between turns of the wheel.
; Decrease it to have the wheel turn faster:
WheelDelay = 150

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.

#SingleInstance

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonClick%, ButtonClick
Hotkey, %JoystickPrefix%%ButtonBack%, ButtonBack
Hotkey, %JoystickPrefix%%ButtonPlay%, ButtonPlay
Hotkey, %JoystickPrefix%%ButtonSearch%, ButtonSearch

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
    YAxisMultiplier = -1
else
    YAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.
SetTimer, WatchProcess, 100  ; Checks if Netflix is still open.

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
    SetTimer, MouseWheel, %WheelDelay%
#Persistent
SetTitleMatchMode, 2

return  ; End of auto-execute section.


; The subroutines below do not use KeyWait because that would sometimes trap the
; WatchJoystick quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the joystick.

ButtonClick:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
SetTimer, WaitForLeftButtonUp, 10
return



WaitForLeftButtonUp:
if GetKeyState(JoystickPrefix . ButtonClick)
    return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForLeftButtonUp, off
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, U  ; Release the mouse button.
return


WatchJoystick:
MouseNeedsToBeMoved := false  ; Set default.
SetFormat, float, 03
GetKeyState, joyx, %JoystickNumber%JoyX
GetKeyState, joyy, %JoystickNumber%JoyY
if joyx > %JoyThresholdUpper%
{
    MouseNeedsToBeMoved := true
    DeltaX := joyx - JoyThresholdUpper
}
else if joyx < %JoyThresholdLower%
{
    MouseNeedsToBeMoved := true
    DeltaX := joyx - JoyThresholdLower
}
else
    DeltaX = 0
if joyy > %JoyThresholdUpper%
{
    MouseNeedsToBeMoved := true
    DeltaY := joyy - JoyThresholdUpper
}
else if joyy < %JoyThresholdLower%
{
    MouseNeedsToBeMoved := true
    DeltaY := joyy - JoyThresholdLower
}
else
    DeltaY = 0
if MouseNeedsToBeMoved
{
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
}
return

WatchVolume:
GetKeyState, JoyExistR, %JoystickNumber%JoyR
If JoyExistR =
{}
else
{
SetFormat, float, 03
GetKeyState, joyr, %JoystickNumber%JoyR
if joyr > %JoyThresholdUpper%
{
    Send {Volume_Down}
}
else if joyr < %JoyThresholdLower%
{
    Send {Volume_Up}
}
}
return

MouseWheel:
GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
if JoyPOV = -1  ; No angle.
    return
if (JoyPOV = 27000 or JoyPOV = 0 or JoyPOV = 31500)  ; Forward
    Send {WheelUp}
else if JoyPOV between 9000 and 18000  ; Back
    Send {WheelDown} 
return

ButtonBack:
Process, Close, osk.exe
MouseMove, -1, -1, 0, R ; Jiggle the mouse to bring up the back arrow during playback
MouseMove, 1, 1, 0, R   ; The arrow does appear after a delay, so you'll still need to press twice
CoordMode, Mouse
ImageSearch, foundX, foundY, 0, 0, 500, 250, *TransBlack Back.bmp
If(ErrorLevel == 0){
foundx := foundx + 10
foundy := foundy + 10
Click, %foundX%, %foundY%
}else{

}
return

ButtonPlay: ; Searches for the Resume button, and if it can't find it, sends the play/pause command
ImageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransBlack Resume.bmp
If(ErrorLevel == 0){
foundx := foundx + 20
foundy := foundy + 20
Click, %foundX%, %foundY%
}else{
Send {Media_Play_Pause}
}
return

ButtonSearch:
ImageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, Search.bmp
If(ErrorLevel == 0){
Click, %foundX%, %foundY%
Run osk.exe  ; Opens the On Screen Keyboard
}else{

}
return

; Close Script if Netflix not detected
WatchProcess:
Process, Exist, netflix.exe
If(ErrorLevel == 0){
Process, Close, osk.exe
ExitApp
}
return

; Back + Start to close
joy7::
{
joy8::
{
if getkeystate("joy7")
{
if getkeystate("joy8")
{
Process, Close, osk.exe
CoordMode, Mouse
Click 0, 950 ; Closes Search box if open so app properly closes
Send !{f4}
ExitApp
}}}}
return

; Escape to close
Esc::
Process, Close, osk.exe
CoordMode, Mouse
Click 0, 950 ; This is necessary in case the Search is open
Send !{f4}
ExitApp