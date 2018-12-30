
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
myBox = CreateObjectBox(10, 10, 10)
SetObjectImage(myBox, texture, 0)

do
    if GetRawKeyPressed(27) then exit

    RotateObjectLocalX(myBox, 0.5)
    RotateObjectLocalY(myBox, 0.5)

    Sync()
loop

end
