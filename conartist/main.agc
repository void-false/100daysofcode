SetErrorMode(2)

// set window properties
SetWindowTitle( "conartist" )
SetWindowSize( 1000, 500, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetAntialiasMode(1)

// shadows
SetShadowMappingMode( 3 )
SetShadowSmoothing(0) // random sampling
SetShadowMapSize( 4096, 4096 )
SetShadowRange( -1 ) // use the full camera range
SetShadowBias( 0.0012 ) // offset shadows slightly to avoid shadow artifacts

SetCameraPosition(1, -10, 10, -10)
//SetCameraPosition(1, 0, 10, -10)
SetCameraLookAt(1, 0, 0, 0, 0)

water = CreateObjectBox(100, 0, 100)
SetObjectColor(water, 59, 209, 158, 255)



rock1 = CreateObjectBox(1.61, 1.61, 1.61)
SetObjectColor(rock1, 161, 173, 150, 0)
SetObjectPosition(rock1, 0, 0.75, 0)
//RotateObjectLocalY(rock, 65)

rock2 = CreateObjectBox(1.0, 1.31, 1.21)
SetObjectColor(rock2, 161, 173, 150, 0)
SetObjectPosition(rock2, 0, 0.65, -0.5)

rock3 = CreateObjectBox(1.0, 0.9, 0.7)
SetObjectColor(rock3, 161, 173, 150, 0)
SetObjectPosition(rock3, 0.5, 0.45, -1.15)

rock4 = CreateObjectBox(1.0, 1.0, 1.1)
SetObjectColor(rock4, 161, 173, 150, 0)
SetObjectPosition(rock4, -1.2, 0.5, 0)

rock5 = CreateObjectBox(1.61, 1.2, 1.61)
SetObjectColor(rock5, 161, 173, 150, 0)
SetObjectPosition(rock5, -0.3, 0.6, 0.6)

grass1 = CreateObjectBox(10, 0.3, 20)
SetObjectPosition(grass1, 5.3, 0.15, 3)
SetObjectColor(grass1, 135, 228, 0, 255)

grass2 = CreateObjectBox(10, 0.3, 3)
SetObjectPosition(grass2, 4.2, 0.15, -3.5)
SetObjectColor(grass2, 135, 228, 0, 255)


SetObjectCastShadow(rock1, 1)
SetObjectCastShadow(rock2, 1)
SetObjectCastShadow(rock3, 1)
SetObjectCastShadow(rock4, 1)
SetObjectCastShadow(rock5, 1)
SetObjectCastShadow(grass1, 1)
SetObjectCastShadow(grass2, 1)

//SetObjectReceiveShadow(water, 1)
//SetObjectLightMode(water, 1)

camSpeed as float = 0.1


do
    if GetRawKeyPressed(27) then exit
    
    
    if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, camSpeed)
	if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -camSpeed)
	if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -camSpeed)
	if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, camSpeed)
	if GetRawKeyState(asc("Q")) and not GetRawKeyState(16) then MoveCameraLocalY(1, camSpeed)
	if GetRawKeyState(asc("Z")) and not GetRawKeyState(16) then MoveCameraLocalY(1, -camSpeed)
	if GetRawKeyState(asc("R")) and not GetRawKeyState(16) then RotateObjectLocalY(rock1, 1)
	if GetRawKeyState(asc("R")) and GetRawKeyState(16) then RotateObjectLocalY(rock1, -1)


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
