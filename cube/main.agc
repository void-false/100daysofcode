
SetWindowTitle( "cube" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

texture = LoadImage("cup.jpg")
box1 = CreateObjectBox(3, 3, 3)
box2 = CreateObjectBox(3, 3, 3)
SetObjectImage(box1, texture, 0)
SetObjectImage(box2, texture, 0)

SetObjectPosition(box1, -5, 1, 1)
SetObjectPosition(box2, 5, 1, 1)

i as float = 0.01

do
    if GetRawKeyPressed(27) then exit

    RotateObjectLocalX(box1, 0.5)
    RotateObjectLocalY(box1, 0.5)
    RotateObjectLocalX(box2, -0.5)
    RotateObjectLocalY(box2, -0.5)
	SetObjectPosition(box1, GetObjectX(box1)+i, 1, 1)
	SetObjectPosition(box2, GetObjectX(box2)-i, 2, 2)
	i = i + 0.0001

    Sync()
loop

end
