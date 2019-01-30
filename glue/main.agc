SetErrorMode(2)

// set window properties
SetWindowTitle( "glue" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

gun = CreateObjectBox(0.02, 0.1, 0.05)
SetObjectPosition(gun, 0, -0.03, -0.01)
RotateObjectLocalX(gun, 15)
FixObjectPivot(gun)

handle = CreateObjectBox(0.025, 0.02, 0.05)
SetObjectPosition(handle, 0, 0.015, 0)
FixObjectToObject(handle, gun)

body = CreateObjectBox(0.02, 0.05, 0.08)
SetObjectPosition(body, 0, 0.03, 0.06)
FixObjectToObject(body, gun)

drum = CreateObjectCylinder(0.06, 0.06, 6)
RotateObjectLocalX(drum, 90)
SetObjectPosition(drum, 0, 0.024, 0.06)
FixObjectToObject(drum, gun)

barrel = CreateObjectCylinder(0.2, 0.02, 10)
RotateObjectLocalX(barrel, 90)
SetObjectPosition(barrel, 0, 0.043, 0.19)
FixObjectToObject(barrel, gun)

sight = CreateObjectCone(0.01, 0.01, 3)
SetObjectPosition(sight, 0, 0.057, 0.28)
FixObjectToObject(sight, gun)

hammer = CreateObjectBox(0.01, 0.01, 0.04)
SetObjectPosition(hammer, 0, 0.005, -0.02)
FixObjectPivot(hammer)
SetObjectPosition(hammer, 0, 0.025, 0.01)
FixObjectToObject(hammer, gun)

hammerAxis = CreateObjectCylinder(0.018, 0.015, 10)
SetObjectPosition(hammerAxis, 0, 0.03, 0.015)
RotateObjectLocalZ(hammerAxis, 90)
FixObjectToObject(hammerAxis, gun)


trigger = CreateObjectBox(0.01, 0.01, 0.04)
SetObjectPosition(trigger, 0, 0.005, 0.02)
FixObjectPivot(trigger)
RotateObjectLocalX(trigger, 45)
SetObjectPosition(trigger, 0, -0.015, 0.015)
FixObjectToObject(trigger, gun)

triggerAxis = CreateObjectCylinder(0.018, 0.01, 10)
SetObjectPosition(triggerAxis, 0, -0.012, 0.023)
RotateObjectLocalZ(triggerAxis, 90)
FixObjectToObject(triggerAxis, gun)

RotateObjectLocalX(gun, 45)
FixObjectPivot(gun)

SetCameraPosition(1, 0.5, 0, 0)
SetCameraRange(1, 0.01, 1000)
SetCameraLookAt(1, 0, 0, 0, 0)

do
    if GetRawKeyPressed(27) then exit
    
	if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, 0.01)
	if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -0.01)
	if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -0.01)
	if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, 0.01)
	if GetRawKeyState(asc("Q")) and not GetRawKeyState(16) then MoveCameraLocalY(1, 0.01)
	if GetRawKeyState(asc("Z")) and not GetRawKeyState(16) then MoveCameraLocalY(1, -0.01)
	
	if GetRawKeyState(asc("W")) and GetRawKeyState(16) then MoveObjectLocalZ(gun, 0.01)
	if GetRawKeyState(asc("S")) and GetRawKeyState(16) then MoveObjectLocalZ(gun, -0.01)
	if GetRawKeyState(asc("A")) and GetRawKeyState(16) then RotateObjectLocalX(gun, 1)
	if GetRawKeyState(asc("D")) and GetRawKeyState(16) then RotateObjectLocalX(gun, -1)

	if GetRawKeyState(asc("V")) then RotateObjectLocalX(hammer, 1)
	if GetRawKeyState(asc("V")) and GetRawKeyState(16) then RotateObjectLocalX(hammer, -2)
	if GetRawKeyState(asc("R")) then RotateObjectLocalX(trigger, 1)
	if GetRawKeyState(asc("R")) and GetRawKeyState(16) then RotateObjectLocalX(trigger, -2)

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
    Sync()
loop

end
