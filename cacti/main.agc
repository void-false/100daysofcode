SetErrorMode(2)

// set window properties
SetWindowTitle( "cacti" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 0, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Create3DPhysicsWorld(1)

cacti1a = CreateObjectBox(0.5, 1, 0.5)
SetObjectColor(cacti1a, 58, 224, 49, 255)
RotateObjectLocalY(cacti1a, 45)
SetObjectPosition(cacti1a, 0, 0.5, 0)

cacti1b = CreateObjectBox(0.5, 1, 0.5)
SetObjectColor(cacti1b, 58, 224, 49, 255)
RotateObjectLocalY(cacti1b, 45)
SetObjectPosition(cacti1b, 0, 1.5, 0)

SetCameraPosition(1, 0, 1.8, -3)
SetCameraLookAt(1, 0, 1, 0, 0)

do
    if GetRawKeyPressed(27) then exit
    
    if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, 0.01)
	if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -0.01)
	if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -0.01)
	if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, 0.01)
	if GetRawKeyState(asc("Q")) and not GetRawKeyState(16) then MoveCameraLocalY(1, 0.01)
	if GetRawKeyState(asc("Z")) and not GetRawKeyState(16) then MoveCameraLocalY(1, -0.01)

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

    Step3DPhysicsWorld()
    Sync()
loop

end
