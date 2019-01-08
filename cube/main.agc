SetErrorMode(2)

// set window properties
SetWindowTitle( "playground" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetAntialiasMode(1)
SetSkyBoxVisible(1)

waterImg = LoadImage("ground.jpg")
SetImageWrapU(waterImg, 1)
SetImageWrapV(waterImg, 1)

rockImg = LoadImage("rock.jpg")
r1 = CreateObjectBox(10, 10, 10)
SetObjectImage(r1, rockImg, 0)
SetObjectPosition(r1, 0, 0, 0)

r2 = CreateObjectBox(10, 20, 10)
SetObjectImage(r2, rockImg, 0)
SetObjectPosition(r2, -10, 0, 0)

r3 = CreateObjectBox(10, 30, 10)
SetObjectImage(r3, rockImg, 0)
SetObjectPosition(r3, -20, 0, 0)

plane = CreateObjectPlane(1600, 1600)
SetObjectImage(plane, waterImg, 0)
SetObjectUVScale(plane, 0, 50, 50)
RotateObjectGlobalX(plane, 90)
SetObjectPosition(plane, 0, -2, 0)
SetObjectCollisionMode(plane, 0)

cone = CreateObjectSphere(10, 20, 20)
SetObjectImage(cone, LoadImage("fire.jpg"), 0)
SetObjectPosition(cone, 40, 0, 0)
SetObjectCollisionMode(cone, 0)

isJumping as integer = 0
isFalling as integer = 0
moveSpeed as float = 0.5
impulse as float = 1.5
i as float = 0.0

SetCameraPosition(1, 25, 30, -70)
SetCameraRotation(1, 0, -10, 0)
SetCameraLookAt(1, 0, 0, 0, 0)

do
	if GetRawKeyPressed(27) then exit
	gosub checkJump
	gosub checkMove


    Sync()
loop

end

checkMove:
	oldX = GetObjectX(cone) : oldY = GetObjectY(cone) : oldZ = GetObjectZ(cone)
	
	if GetRawKeyState(asc("A")) then MoveObjectLocalX(cone, -moveSpeed)
	if GetRawKeyState(asc("D")) then MoveObjectLocalX(cone, moveSpeed)
	
	newX = GetObjectX(cone) : newY = GetObjectY(cone) : newZ = GetObjectZ(cone)
	objectHit = ObjectSphereSlide(0, oldX, oldY, oldZ, newX, newY, newZ, 5)
	if objectHit <> 0
		isFalling = 0
		SetObjectPosition(cone, oldX, oldY, oldZ)
	endif
	
	Print(objectHit)
return

checkJump:
	if GetRawKeyPressed(asc(" ")) and not isJumping and not isFalling
		isJumping = 1
		i = impulse
		
	endif

	if isJumping
		if i >= 0
			MoveObjectLocalY(cone, i)
			i = i - 0.1
		else 
			isJumping = 0
			isFalling = 1
			i = 0
		endif
	endif
	
	if isFalling
		MoveObjectLocalY(cone, -i)
		i = i + 0.1
		if GetObjectY(cone) <= 0
			SetObjectPosition(cone, GetObjectX(cone), 0, GetObjectZ(cone))
			isFalling = 0
		endif
	endif
return
