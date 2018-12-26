SetErrorMode(2)

// set window properties
SetWindowTitle( "playground" )
SetWindowSize( 800, 600, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 800, 600 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
//SetRawMouseVisible(0)

//cursor = CreateSprite(LoadImage("cursor.png"))
//SetSpriteSize(cursor, 24, 24)
s1 = CreateSprite(CreateImageColor(255, 155, 0, 255))
SetSpriteSize(s1, 100, 100)
SetSpritePosition(s1, 50, 50)

s2 = CreateSprite(0)
SetSpriteSize(s2, 300, 300)
SetSpritePosition(s2, 250, 150)
SetSpriteColor(s2, 200, 0, 0, 255)


offsetX as integer = 0
offsetY as integer = 0
isHolding as integer = 0

do
	if GetRawKeyPressed(27) then exit
	//SetSpritePosition(cursor, GetPointerX(), GetPointerY())
	//SetSpriteDepth(cursor, 0)
	
	if GetPointerPressed() and GetSpriteHitTest(s1, GetPointerX(), GetPointerY())
		isHolding = 1
		tester = CloneSprite(s1)
		SetSpriteColor(tester, 100, 100, 100, 100)
		SetSpriteVisible(tester, 1)
		offsetX = GetPointerX() - GetSpriteX(tester)
		offsetY = GetPointerY() - GetSpriteY(tester)
	
	elseif GetPointerState() and isHolding
		SetSpritePosition(tester, GetPointerX() - offsetX, GetPointerY() - offsetY)
		
		gosub checkCollision
		gosub checkBounds
		
	elseif GetPointerReleased()
		SetSpriteColor(s1, 255, 255, 255, 255)
		isHolding = 0
		DeleteSprite(tester)
	endif
    Sync()
loop

end

checkCollision:	

	count = 0
	speed = 1
	currentsx = GetSpriteX(s1)
	currentsy = GetSpriteY(s1)
	currenttx = GetSpriteX(tester)
	currentty = GetSpriteY(tester)
	while currentsx-currenttx <> 0 or currentsy-currentty <> 0

		if currentsx < currenttx 
			direction = speed
		elseif currentsx > currenttx
			direction = -speed
		else  
			direction = 0
		endif
		SetSpritePosition(s1, currentsx+direction, currentsy)
		if GetSpriteCollision(s1, s2)
			SetSpritePosition(s1, currentsx, currentsy)
		else
			currentsx = currentsx + direction
			didMove = 1
		endif
		
		
		if currentsy < currentty
			direction = speed
		elseif currentsy > currentty
			direction = -speed
		else
			direction = 0
		endif
		SetSpritePosition(s1, currentsx, currentsy+direction)
		if GetSpriteCollision(s1, s2)
			SetSpritePosition(s1, currentsx, currentsy)
		else
			currentsy = currentsy + direction
			didMove = 1
		endif
		
		inc count
		if count > 60
			SetSpriteColor(s1, 255, 0, 0, 255)
			exit
		endif

		
	endwhile
	Print((currentsx))
	Print((currentsy))
	Print((currenttx))
	Print((currentty))
	
	
return

checkBounds:
	if GetSpriteX(s1) < 0 then SetSpritePosition(s1, 0, GetSpriteY(s1))
	if GetSpriteY(s1) < 0 then SetSpritePosition(s1, GetSpriteX(s1), 0)
	if GetSpriteX(s1) > GetVirtualWidth()-GetSpriteWidth(s1) then SetSpritePosition(s1, GetVirtualWidth()-GetSpriteWidth(s1), GetSpriteY(s1))
	if GetSpriteY(s1) > GetVirtualHeight()-GetSpriteHeight(s1) then SetSpritePosition(s1, GetSpriteX(s1), GetVirtualHeight()-GetSpriteHeight(s1))
return
