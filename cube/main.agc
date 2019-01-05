
SetWindowTitle( "cube" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetRawMouseVisible(0)

texture = LoadImage("cup.jpg")
grassImg = LoadImage("grass.jpg")
SetImageWrapU(grassImg, 1)
SetImageWrapV(grassImg, 1)
ground = CreateObjectPlane(1600, 1600)
SetObjectImage(ground, grassImg, 0)
SetObjectUVScale(ground, 0, 30, 30)
RotateObjectGlobalX(ground, 90)

cx = GetVirtualWidth()/2
cy = GetVirtualHeight()/2
SetCameraRotation(1, 0, 0, 0)
SetCameraPosition(1, 0, 10, 0)


for i = 0 to 50
	b1 = CreateObjectBox(Random(15, 35), Random(10, 150), Random(15, 35))
	SetObjectImage(b1, texture, 0)
	SetObjectPosition(b1, Random(0, 600) - 300, 0, Random(50, 500))
next i



moveSpeed as float = 0.5
mouseSpeed as float = 8.0

do
    if GetRawKeyPressed(27) then exit

	mx = GetPointerX() - cx
	my = GetPointerY() - cy	
	xmove = xmove + mx
	ymove = ymove + my
	SetCameraRotation(1, ymove/mouseSpeed, xmove/mouseSpeed, 0)	
	//SetCameraRotation(1, ymove, xmove, 0)	
	SetRawMousePosition(cx, cy)
	
	if GetRawKeyState(asc("W")) then MoveCameraLocalZ(1, moveSpeed)
	if GetRawKeyState(asc("S")) then MoveCameraLocalZ(1, -moveSpeed)
	if GetRawKeyState(asc("A")) then MoveCameraLocalX(1, -moveSpeed)
	if GetRawKeyState(asc("D")) then MoveCameraLocalX(1, moveSpeed)

	SetCameraPosition(1, GetCameraX(1), 10, GetCameraZ(1))

    Sync()
loop

end
