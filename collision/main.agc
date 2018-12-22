SetErrorMode(2)

// set window properties
SetWindowTitle( "Collision" )
SetWindowSize( 800, 600, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 800, 600 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

s1 = CreateSprite(0)
SetSpriteSize(s1, 50, 50)
SetSpriteColor(s1, 0, 200, 0, 255)
SetSpritePosition(s1, 0, 0)

type Wall
	id as integer
	x as integer
	y as integer
	w as integer
	h as integer
	
endtype

#constant MAXWALLS 5

walls as Wall[MAXWALLS]
wallColor = CreateImageColor(200,100,100,255)

walls[0].id = CreateSprite(wallColor)
SetSpriteSize(walls[0].id, 100, 200)
SetSpritePosition(walls[0].id, 350, 0)

walls[1].id = CreateSprite(wallColor)
SetSpriteSize(walls[1].id, 100, 250)
SetSpritePosition(walls[1].id, 350, 300)

walls[2].id = CreateSprite(wallColor)
SetSpriteSize(walls[2].id, 100, 300)
SetSpritePosition(walls[2].id, 510, 150)

walls[3].id = CreateSprite(wallColor)
SetSpriteSize(walls[3].id, 350, 80)
SetSpritePosition(walls[3].id, 450, 0)

walls[4].id = CreateSprite(wallColor)
SetSpriteSize(walls[4].id, 350, 100)
SetSpritePosition(walls[4].id, 0, 450)

isHolding as integer = 0
tester = CloneSprite(s1)
SetSpriteColor(tester, 100, 100, 100, 100)
SetSpriteVisible(tester, 0)

do
	if GetRawKeyPressed(27) then end
	
	if GetPointerPressed() and GetSpriteHitTest(s1, GetPointerX(), GetPointerY())
		isHolding = 1
		SetSpriteOffset(s1, GetPointerX()-GetSpriteX(s1), GetPointerY()-GetSpriteY(s1))
		SetSpriteOffset(tester, GetPointerX()-GetSpriteX(tester), GetPointerY()-GetSpriteY(tester))
	endif
	if GetPointerState() and isHolding
		gosub updatePosition
		gosub checkBounds
	elseif GetPointerReleased()
		SetSpritePosition(tester, GetSpriteX(s1), GetSpriteY(s1))
		isHolding = 0
	endif
	//PrintC(str(GetPointerX()) + ":" + str(GetPointerY()))
	sync()
loop

updatePosition:
	isCollide = 0
	SetSpritePositionByOffset(tester, GetPointerX(), GetPointerY())
	for i = 0 to MAXWALLS-1
		if GetSpriteCollision(tester, walls[i].id)
			SetSpritePosition(tester, GetSpriteX(s1), GetSpriteY(s1))
			isCollide = 1
			exit
		endif
	next i
	if not isCollide
		SetSpritePositionByOffset(s1, GetPointerX(), GetPointerY())
	endif
return

checkBounds:
	if GetSpriteX(s1) < 0 
		SetSpritePosition(s1, 0, GetSpriteY(s1))
	elseif GetSpriteX(s1) > GetVirtualWidth()-GetSpriteWidth(s1) 
		SetSpritePosition(s1, GetVirtualWidth()-GetSpriteWidth(s1), GetSpriteY(s1))
	endif
	
	if GetSpriteY(s1) < 0 
		SetSpritePosition(s1, GetSpriteX(s1), 0)
	elseif GetSpriteY(s1) > GetVirtualHeight()-GetSpriteHeight(s1) 
		SetSpritePosition(s1, GetSpriteX(s1), GetVirtualHeight()-GetSpriteHeight(s1))
	endif
return
