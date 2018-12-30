
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


for i = 0 to 1500
	b = CreateObjectBox(Random(1,15), Random(1,15), Random(1,15))
	SetObjectImage(b, texture, 0)
	RotateObjectLocalX(b, Random(1, 180))
    RotateObjectLocalY(b, Random(1, 180))
    RotateObjectLocalZ(b, Random(1, 180))
    SetObjectPosition(b, Random(-1000, 1000), Random(-1000, 1000), Random(-1000, 1000))
next i

do
    if GetRawKeyPressed(27) then exit


    if GetRawKeyState(asc("W")) then MoveCameraLocalZ(1, 1)
    if GetRawKeyState(asc("S")) then MoveCameraLocalZ(1, -1)
    if GetRawKeyState(asc("A")) then MoveCameraLocalX(1, -1)
    if GetRawKeyState(asc("D")) then MoveCameraLocalX(1, 1)
    if GetRawKeyState(asc("Q")) then MoveCameraLocalY(1, 1)
    if GetRawKeyState(asc("Z")) then MoveCameraLocalY(1, -1)
    if GetRawKeyState(asc("X")) then RotateCameraLocalY(1, -1)
    if GetRawKeyState(asc("C")) then RotateCameraLocalY(1, 1)
    if GetRawKeyState(asc("E")) then RotateCameraLocalZ(1, 1)
    if GetRawKeyState(asc("R")) then RotateCameraLocalZ(1, -1)

    
    Sync()
loop

end
