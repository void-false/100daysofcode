SetErrorMode(2)

// set window properties
SetWindowTitle( "game15" )
SetWindowSize( 625, 625, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 625, 625 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

#constant NUMSQUARES 15
#constant NUMROWS 4
#constant SIZE 150
#constant GAP 152

squares as integer[NUMSQUARES]
labels as integer[NUMSQUARES]

sx = 50
sy = 10
for i = 0 to NUMSQUARES-1
	squares[i] = CreateSprite(0)
	SetSpriteSize(squares[i], SIZE, SIZE)
	sx = GAP * mod(i, NUMROWS) + 10
	if mod(i, NUMROWS) = 0 and i <> 0 then sy = sy + GAP
	SetSpritePosition(squares[i], sx, sy)
	inc sx
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
	labels[i] = CreateText(str(i + 1))
	SetTextSize(labels[i], 72)
	SetTextColor(labels[i], 200, 0, 0, 255)
	SetTextPosition(labels[i], GetSpriteX(squares[i]), GetSpriteY(squares[i]))
next i

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
		gosub checkBounds
		gosub updateLabels
	elseif GetPointerReleased()
		isHolding = 0
		DeleteSprite(tester)
	endif
	//PrintC(str(GetPointerX()) + ":" + str(GetPointerY()))
	sync()
loop

updatePosition:
	didCollide = 0
	for i = 0 to NUMSQUARES-1
		if squares[i] = clickedSprite then continue
		if GetSpriteCollision(tester, squares[i])
			didCollide = 1
			exit
		endif
	next i
	if not didCollide
		SetSpritePosition(clickedSprite, GetSpriteX(tester), GetSpriteY(tester))
	else
		oldx = GetSpriteX(clickedSprite)
		oldy = GetSpriteY(clickedSprite)
		
		SetSpritePosition(clickedSprite, oldx, GetSpriteY(tester))
		didCollide = 0
		gosub checkCollision
		if didCollide
			SetSpritePosition(clickedSprite, oldx, oldy)
		else 
			oldy = GetSpriteY(clickedSprite)
		endif
		
		SetSpritePosition(clickedSprite, GetSpriteX(tester), oldy)
		didCollide = 0
		gosub checkCollision
		if didCollide
			SetSpritePosition(clickedSprite, oldx, oldy)
		endif
	endif
		
return

checkCollision:
	for i = 0 to NUMSQUARES-1
		if squares[i] = clickedSprite then continue
		if GetSpriteCollision(clickedSprite, squares[i])
			didCollide = 1
			exit
		endif
	next i
return

checkBounds:
	if GetSpriteX(clickedSprite) < 0 
		SetSpritePosition(clickedSprite, 0, GetSpriteY(clickedSprite))
	elseif GetSpriteX(clickedSprite) > GetVirtualWidth()-GetSpriteWidth(clickedSprite) 
		SetSpritePosition(clickedSprite, GetVirtualWidth()-GetSpriteWidth(clickedSprite), GetSpriteY(clickedSprite))
	endif
	
	if GetSpriteY(clickedSprite) < 0 
		SetSpritePosition(clickedSprite, GetSpriteX(clickedSprite), 0)
	elseif GetSpriteY(clickedSprite) > GetVirtualHeight()-GetSpriteHeight(clickedSprite) 
		SetSpritePosition(clickedSprite, GetSpriteX(clickedSprite), GetVirtualHeight()-GetSpriteHeight(clickedSprite))
	endif
return

updateLabels:
	for i = 0 to NUMSQUARES-1
		SetTextPosition(labels[i], GetSpriteX(squares[i]), GetSpriteY(squares[i]))
	next i
return

end
