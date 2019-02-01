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
SetAntialiasMode(1)


Create3DPhysicsWorld(1)

SetSkyBoxVisible(1)

// shadows
SetShadowMappingMode( 3 )
SetShadowSmoothing( 0 ) // random sampling
SetShadowMapSize( 1024, 1024 )
SetShadowRange( -1 ) // use the full camera range
SetShadowBias( 0.0012 ) // offset shadows slightly to avoid shadow artifacts

cacti1a = CreateObjectCapsule(0.5, 1.2, 1)
SetObjectColor(cacti1a, 58, 224, 49, 255)
SetObjectPosition(cacti1a, 0, 0.6, 0)
SetObjectCastShadow(cacti1a, 1)

cacti1b = CreateObjectCapsule(0.5, 1.2, 1)
SetObjectColor(cacti1b, 58, 224, 49, 255)
SetObjectPosition(cacti1b, GetObjectX(cacti1a), GetObjectY(cacti1a)+1, GetObjectZ(cacti1a))
SetObjectCastShadow(cacti1b, 1)

cacti1c = CreateObjectCapsule(0.3, 0.7, 0)
SetObjectColor(cacti1c, 58, 224, 49, 255)
SetObjectPosition(cacti1c, GetObjectX(cacti1a)+0.4, GetObjectY(cacti1a), GetObjectZ(cacti1a))
SetObjectCastShadow(cacti1c, 1)

cacti1d = CreateObjectCapsule(0.3, 1.1, 1)
SetObjectColor(cacti1d, 58, 224, 49, 255)
SetObjectPosition(cacti1d, GetObjectX(cacti1c)+0.25, GetObjectY(cacti1c)+0.45, GetObjectZ(cacti1c))
SetObjectCastShadow(cacti1d, 1)

cacti1e = CreateObjectCapsule(0.2, 0.7, 0)
SetObjectColor(cacti1e, 58, 224, 49, 255)
SetObjectPosition(cacti1e, GetObjectX(cacti1b)-0.25, GetObjectY(cacti1b), GetObjectZ(cacti1b))
SetObjectCastShadow(cacti1e, 1)

cacti1f = CreateObjectCapsule(0.2, 0.9, 1)
SetObjectColor(cacti1f, 58, 224, 49, 255)
SetObjectPosition(cacti1f, GetObjectX(cacti1e)-0.25, GetObjectY(cacti1e)+0.35, GetObjectZ(cacti1e))
SetObjectCastShadow(cacti1f, 1)

ground = CreateObjectBox(100, 0.01, 100)
SetObjectColor(ground, 244, 194, 44, 255)
SetObjectCastShadow(ground, 1)
SetObjectReceiveShadow(ground, 1)
SetObjectLightMode(ground, 1)


Create3DPhysicsKinematicBody(ground)

SetCameraPosition(1, 0, 1.8, -5)
SetCameraLookAt(1, 0, 1, 0, 0)

dw as float
dh as float
dl as float

do
    if GetRawKeyPressed(27) then exit
    
    if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, 0.01)
	if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -0.01)
	if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -0.01)
	if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, 0.01)
	if GetRawKeyState(asc("Q")) and not GetRawKeyState(16) then MoveCameraLocalY(1, 0.01)
	if GetRawKeyState(asc("Z")) and not GetRawKeyState(16) then MoveCameraLocalY(1, -0.01)
	if GetRawKeyPressed(asc(" ")) then gosub explodeCacti


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

explodeCacti:
	i as float
	SetObjectVisible(cacti1b, 0)
	SetObjectVisible(cacti1e, 0)
	SetObjectVisible(cacti1f, 0)
	
	for i = -0.2 to 0.2 step 0.1		
		dw = Random(10, 20) / 100.0
		dh = Random(30, 60) / 100.0
		dl = Random(5, 10) / 100.0
		debris = CreateObjectBox(dw, dh, dl)
		SetObjectColor(debris, 58, 224, 49, 255)
		SetObjectPosition(debris, GetObjectX(cacti1b)+i, GetObjectY(cacti1b)+i, GetObjectZ(cacti1b)+i)
		Create3DPhysicsDynamicBody(debris)
		//SetObject3DPhysicsAngularVelocity(debris, Random(0,2)-1, Random(0,2)-1, Random(0,2)-1, Random(10,20))
		//SetObject3DPhysicsLinearVelocity(debris, Random(0,2)-1, Random(2,3), Random(0,2)-1, Random(1,4))
		SetObjectCastShadow(debris, 1)
	next i	

return
