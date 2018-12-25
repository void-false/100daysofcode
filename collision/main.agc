SetErrorMode(2)

// set window properties
SetWindowTitle( "playground" )
SetWindowSize( 800, 600, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 800, 600 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

s1 = CreateSprite(CreateImageColor(255, 155, 0, 255))
SetSpriteSize(s1, 100, 100)

s2 = CreateSprite(0)
SetSpriteSize(s2, 300, 300)
SetSpritePosition(s2, 250, 150)
SetSpriteColor(s2, 200, 0, 0, 255)




isHolding = 0

do
	if GetRawKeyPressed(27) then exit
	
	if GetPointerPressed() and GetSpriteHitTest(s1, GetPointerX(), GetPointerY())
		isHolding = 1
		tester = CloneSprite(s1)
		SetSpriteColor(tester, 100, 100, 100, 100)
		SetSpriteOffset(tester, GetPointerX() - GetSpriteX(tester), GetPointerY() - GetSpriteY(tester))
	endif
	
	if GetPointerState() and isHolding
		SetSpritePositionByOffset(tester, GetPointerX(), GetPointerY())
		
		gosub checkCollision
		gosub checkBounds
		
	elseif GetPointerReleased()
		isHolding = 0
		DeleteSprite(tester)
	endif

    Sync()
loop

end

checkCollision:	
	Print(GetSpriteOffsetX(tester))
	Print(GetSpriteOffsetY(tester))

	if not GetSpriteCollision(tester, s2)
		Print("CLEAR")
		SetSpritePosition(s1, GetSpriteX(tester), GetSpriteY(tester))
	else
		Print("COLLISION")
		oldx = GetSpriteX(s1)
		oldy = GetSpriteY(s1)
		
		SetSpritePosition(s1, oldx, GetSpriteY(tester))
		if GetSpriteCollision(s1, s2)
			SetSpritePosition(s1, oldx, oldy)
		else 
			oldy = GetSpriteY(s1)
		endif
		
		SetSpritePosition(s1, GetSpriteX(tester), oldy)
		if GetSpriteCollision(s1, s2)
			SetSpritePosition(s1, oldx, oldy)
		endif
		
	endif
return

checkBounds:
	if GetSpriteX(s1) < 0 then SetSpritePosition(s1, 0, GetSpriteY(s1))
	if GetSpriteY(s1) < 0 then SetSpritePosition(s1, GetSpriteX(s1), 0)
return
