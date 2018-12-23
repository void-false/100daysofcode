SetErrorMode(2)

// set window properties
SetWindowTitle( "game15" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

#constant NUMSQUARES 15
#constant NUMROWS 4
#constant SIZE 150
#constant GAP 170


squares as integer[NUMSQUARES]

sx = 50
sy = 50
for i = 0 to NUMSQUARES-1
	squares[i] = CreateSprite(0)
	SetSpriteSize(squares[i], SIZE, SIZE)
	sx = GAP * mod(i, NUMROWS) + 50
	if mod(i, NUMROWS) = 0 and i <> 0 then sy = sy + GAP
	SetSpritePosition(squares[i], sx, sy)
	inc sx
next i
do
    if GetRawKeyPressed(27) then exit
    Sync()
loop

end
