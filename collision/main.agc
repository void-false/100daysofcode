SetErrorMode(2)

// set window properties
SetWindowTitle( "Collision" )
SetWindowSize( 800, 600, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 800, 600 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

s1 = CreateSprite(0)
SetSpriteSize(s1, 100, 100)
SetSpritePosition(s1, (GetVirtualWidth()-GetSpriteWidth(s1))/10,(GetVirtualHeight()-GetSpriteHeight(s1))/10)

s2 = CreateSprite(0)
SetSpriteColor(s2, 200,100,100,255)
SetSpriteSize(s2, 400, 250)
SetSpritePosition(s2, (GetVirtualWidth()-GetSpriteWidth(s2))/2,(GetVirtualHeight()-GetSpriteHeight(s2))/2)


isHolding as integer = 0

do
	if GetRawKeyPressed(27) then end
	
	if GetPointerPressed() and GetSpriteHitTest(s1, GetPointerX(), GetPointerY())
		isHolding = 1
		SetSpriteOffset(s1, GetPointerX()-GetSpriteX(s1), GetPointerY()-GetSpriteY(s1))
	endif
	if GetPointerState() and isHolding
		SetSpritePositionByOffset(s1, GetPointerX(), GetPointerY())
		gosub checkBounds
		gosub checkCollision
	elseif GetPointerReleased()
		isHolding = 0
	endif

	sync()
loop
	
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

checkCollision:
	if GetSpriteCollision(s1, s2)
		Print("COLLISION!")
		if GetSpriteX(s1) < GetSpriteX(s2)
			SetSpritePosition(s1, GetSpriteX(s2)-GetSpriteWidth(s1)-1, GetSpriteY(s1))
		endif
		if GetSpriteX(s1) > GetSpriteX(s2)
			SetSpritePosition(s1, GetSpriteX(s2)+GetSpriteWidth(s2)+1, GetSpriteY(s1))
		endif
		/*if GetSpriteY(s1) > GetSpriteY(s2)
			SetSpritePosition(s1, GetSpriteX(s1), GetSpriteY(s2)+GetSpriteHeight(s2)+1)
		
		else //if GetSpriteY(s1) < GetSpriteY(s2)
			SetSpritePosition(s1, GetSpriteX(s1), GetSpriteY(s2)-GetSpriteHeight(s1)-1)
		endif*/
		
		
	endif
return
