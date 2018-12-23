SetErrorMode(2)

// set window properties
SetWindowTitle( "game15" )
SetWindowSize( 760, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 760, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

#constant NUMSQUARES 15
#constant NUMROWS 4
#constant SIZE 150
#constant GAP 170

squares as integer[NUMSQUARES]
labels as integer[NUMSQUARES]

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

for i = 0 to NUMSQUARES-1
	labels[i] = CreateText(str(i + 1))
	SetTextSize(labels[i], 72)
	SetTextColor(labels[i], 200, 0, 0, 255)
	SetTextPosition(labels[i], GetSpriteX(squares[i]), GetSpriteY(squares[i]))
next i

isHolding = 0

do
	if GetRawKeyPressed(27) then end
	
	if GetPointerPressed() and GetSpriteHit(GetPointerX(), GetPointerY())
		clickedSprite = GetSpriteHit(GetPointerX(), GetPointerY())
		tester = CloneSprite(clickedSprite)
		SetSpriteVisible(tester, 0)
		isHolding = 1
		SetSpriteOffset(clickedSprite, GetPointerX()-GetSpriteX(clickedSprite), GetPointerY()-GetSpriteY(clickedSprite))
		SetSpriteOffset(tester, GetPointerX()-GetSpriteX(tester), GetPointerY()-GetSpriteY(tester))
	endif
	if GetPointerState() and isHolding
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
	isCollide = 0
	SetSpritePositionByOffset(tester, GetPointerX(), GetPointerY())
	for i = 0 to NUMSQUARES-1
		if squares[i] = clickedSprite then continue
		if GetSpriteCollision(tester, squares[i])
			SetSpritePosition(tester, GetSpriteX(clickedSprite), GetSpriteY(clickedSprite))
			isCollide = 1
			exit
		endif
	next i
	if not isCollide
		SetSpritePositionByOffset(clickedSprite, GetPointerX(), GetPointerY())
	endif
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
