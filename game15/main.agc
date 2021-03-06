SetErrorMode(2)

// set window properties
SetWindowTitle( "game15" )
SetWindowSize( 603, 603, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 603, 603 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

#constant NUMSQUARES 15
#constant ALLOBJECTCOUNT 19
#constant NUMROWS 4
#constant SIZE 150
#constant GAP 151

squares as integer[NUMSQUARES]


sx = 50
sy = 0
for i = 0 to NUMSQUARES-1
	fileName as String
	fileName = str(i+1) + ".png"
	squares[i] = CreateSprite(LoadImage(fileName))
	SetSpriteSize(squares[i], SIZE, SIZE)
next i

temp as integer[NUMSQUARES]
for i = 0 to NUMSQUARES-1
	repeat
		ri = Random(0, NUMSQUARES-1)
	until temp[ri] = 0

	temp[ri] = squares[i]
next i
squares = temp

for i = 0 to NUMSQUARES-1
	sx = GAP * mod(i, NUMROWS)
	if mod(i, NUMROWS) = 0 and i <> 0 then sy = sy + GAP
	SetSpritePosition(squares[i], sx, sy)
	inc sx
next i

allObjects as integer[0]
allObjects = squares
allObjects.length = ALLOBJECTCOUNT
allObjects[15] = CreateSprite(0)
SetSpriteSize(allObjects[15], GetVirtualWidth(), 0)
SetSpritePosition(allObjects[15], 0, -1)
allObjects[16] = CreateSprite(0)
SetSpriteSize(allObjects[16], GetVirtualWidth(), 0)
SetSpritePosition(allObjects[16], 0, GetVirtualHeight()+1)
allObjects[17] = CreateSprite(0)
SetSpriteSize(allObjects[17], 0, GetVirtualHeight())
SetSpritePosition(allObjects[17], -1, 0)
allObjects[18] = CreateSprite(0)
SetSpriteSize(allObjects[18], 0, GetVirtualHeight())
SetSpritePosition(allObjects[18], GetVirtualWidth()+1, 0)

offsetX as integer = 0
offsetY as integer = 0
isHolding as integer = 0

do
	if GetRawKeyPressed(27) then end
	
	if GetPointerPressed() and GetSpriteHit(GetPointerX(), GetPointerY())
		clickedSprite = GetSpriteHit(GetPointerX(), GetPointerY())
		tester = CloneSprite(clickedSprite)
		SetSpriteVisible(tester, 0)
		isHolding = 1
		offsetX = GetPointerX() - GetSpriteX(tester)
		offsetY = GetPointerY() - GetSpriteY(tester)
	
	elseif GetPointerState() and isHolding
		SetSpritePosition(tester, GetPointerX() - offsetX, GetPointerY() - offsetY)		
		gosub updatePosition
	elseif GetPointerReleased()
		isHolding = 0
		DeleteSprite(tester)
	endif
	sync()
loop

updatePosition:
	count = 0
	speed = 1
	didCollide = 0
	currentsx = GetSpriteX(clickedSprite)
	currentsy = GetSpriteY(clickedSprite)
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
		SetSpritePosition(clickedSprite, currentsx+direction, currentsy)
		didCollide = 0
		gosub checkCollision
		if didCollide
			SetSpritePosition(clickedSprite, currentsx, currentsy)
		else
			currentsx = currentsx + direction
		endif
			
		if currentsy < currentty
			direction = speed
		elseif currentsy > currentty
			direction = -speed
		else
			direction = 0
		endif
		SetSpritePosition(clickedSprite, currentsx, currentsy+direction)
		didCollide = 0
		gosub checkCollision
		if didCollide
			SetSpritePosition(clickedSprite, currentsx, currentsy)
		else
			currentsy = currentsy + direction
		endif
		
		inc count
		if count > 60 then exit
	endwhile	
return

checkCollision:
	for i = 0 to ALLOBJECTCOUNT - 1
		if allObjects[i] = clickedSprite then continue
		if GetSpriteCollision(clickedSprite, allObjects[i])
			didCollide = 1
			exit
		endif
	next i
return

end
