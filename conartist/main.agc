SetErrorMode(2)

// set window properties
SetWindowTitle( "conartist" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

SetCameraPosition(1, 0, 10, -10)
SetCameraLookAt(1, 0, 0, 0, 0)

water = CreateObjectBox(100, 0, 100)
SetObjectColor(water, 59, 209, 158, 255)

rock = CreateObjectBox(1.61, 1.61, 1.61)
SetObjectColor(rock, 161, 173, 150, 0)
SetObjectPosition(rock, 0, 0.75, 0)
RotateObjectLocalY(rock, 65)

camSpeed as float = 0.02


do
    if GetRawKeyPressed(27) then exit
    
    
    if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, camSpeed)
	if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -camSpeed)
	if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -camSpeed)
	if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, camSpeed)
	if GetRawKeyState(asc("Q")) and not GetRawKeyState(16) then MoveCameraLocalY(1, camSpeed)
	if GetRawKeyState(asc("Z")) and not GetRawKeyState(16) then MoveCameraLocalY(1, -camSpeed)
	if GetRawKeyState(asc("R")) and not GetRawKeyState(16) then RotateObjectLocalY(rock, 1)
	if GetRawKeyState(asc("R")) and GetRawKeyState(16) then RotateObjectLocalY(rock, -1)


	if GetPointerPressed()
        startx# = GetPointerX()
        starty# = GetPointerY()
        angx# = GetCameraAngleX(1)
        angy# = GetCameraAngleY(1)
    endif
    if GetPointerState()
        fDiffX# = (GetPointerX() - startx#)/2.0
        fDiffY# = (GetPointerY() - starty#)/2.0
        SetCameraRotation( 1, angx# + fDiffY#, angy# + fDiffX#, 0 )
    endif
    
    Print(GetObjectAngleY(rock))
    Print(GetCameraY(1))
    
    Sync()
loop

end
