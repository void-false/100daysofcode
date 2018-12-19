SetErrorMode(2)
SetWindowTitle( "Clear Sky" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetRawMouseVisible(0)
//EnableClearColor(0)

cross = CreateSprite(LoadImage("cross.png"))
SetSpritePosition(cross, -300, -300)
t1 = CreateText("Click to start")
SetTextSize(t1, 100)
SetTextPosition(t1, (GetVirtualWidth()-GetTextTotalWidth(t1))/2, (GetVirtualHeight()-GetTextTotalHeight(t1))/2)
while not GetPointerPressed()
	SetSpritePosition(cross, GetPointerX()-GetSpriteWidth(cross)/2, GetPointerY()-GetSpriteHeight(cross)/2)
	if GetRawKeyPressed(27) then end
	sync()
endwhile
SetTextVisible(t1, 0)
sync() 

#constant MAXBULLETS 100
#constant MAXJETS 10
#constant MAXPARTICLES 150
#constant MAXBOMBS 30
#constant DIRLEFT 0
#constant DIRRIGHT 1

enemyFreq = 10
bulletImage = CreateImageColor(200,0,0,255)
turretX = GetVirtualWidth()/2
turretY = GetVirtualHeight()/1.1
turret = CreateSprite(CreateImageColor(189, 191, 193, 255))
SetSpriteSize(turret, 85, 35)
SetSpritePosition(turret, turretX-GetSpriteWidth(turret)/2, turretY-GetSpriteHeight(turret)/2)

type Jet
	sprite as integer
	alive as integer
	x as float
	y as float
	direction as integer
	speed as integer
endtype

jetImage = LoadImage("jet.png")

jets as Jet[MAXJETS]

for i = 0 to MAXJETS
	jets[i].sprite = CreateSprite(jetImage)
	jets[i].alive = 0
	jets[i].speed = 15
	jets[i].x = -100 : jets[i].y = -100
	jets[i].direction = Random(DIRLEFT,DIRRIGHT)
	if jets[i].direction = DIRLEFT 
		SetSpriteFlip(jets[i].sprite, 1, 0)
		jets[i].speed = -15
	endif
	SetSpritePosition(jets[i].sprite, jets[i].x, jets[i].y)
next i

heli = CreateSprite(LoadImage("heli.png"))
SetSpritePosition(heli, 1700, 150)

particles as integer[MAXPARTICLES]
particleImage = LoadImage("spark.png")
for i = 0 to MAXPARTICLES
	particles[i] = CreateParticles(-300, -300)
	SetParticlesImage(particles[i], particleImage)
	SetParticlesSize(particles[i], 12)
	SetParticlesActive(particles[i], 0)
	SetParticlesLife(particles[i], 1)
	SetParticlesFrequency(particles[i], 100)
	SetParticlesVelocityRange(particles[i], 3,3)
	AddParticlesColorKeyFrame(particles[i], 0, 255, 0, 16, 255)
	AddParticlesColorKeyFrame(particles[i], 0.5, 255, 204, 0, 255)
	AddParticlesColorKeyFrame(particles[i], 1, 237, 236, 232, 0)
next i

type Bullet
	sprite as integer
	alive as integer
	x as float
	y as float
	dx as float
	dy as float
endtype
	
bullets as Bullet[MAXBULLETS]
for i = 0 to MAXBULLETS
	bullets[i].sprite = CreateSprite(bulletImage) 
	bullets[i].alive = 0 
	bullets[i].x = turretX
	bullets[i].y = turretY
	bullets[i].dx = 0
	bullets[i].dx = 0 
	SetSpriteSize(bullets[i].sprite, 15, 15)
	SetSpritePosition(bullets[i].sprite, bullets[i].x, bullets[i].y)
	SetSpriteVisible(bullets[i].sprite, 0)
next i

bombImage = LoadImage("bomb.png")

type Bomb
	sprite as integer
	alive as integer
	x as float
	y as float
	speed as float
endtype

bombs as Bomb[MAXBOMBS]
for i = 0 to MAXBOMBS
	bombs[i].sprite = CreateSprite(bombImage) 
	bombs[i].alive = 0 
	bombs[i].x = -100
	bombs[i].y = -100
	bombs[i].speed = 15
	SetSpritePosition(bombs[i].sprite, bombs[i].x, bombs[i].y)
	SetSpriteVisible(bombs[i].sprite, 0)
next i


currentBullet = 0
currentJet = 0
currentBomb = 0
currentParticle = 0

do

	if GetRawKeyPressed(27) then exit
	if GetPointerPressed()
		
		pointerX = GetPointerX()
		pointerY = GetPointerY()
		sideX = (pointerX - turretX)
		sideY = (pointerY - turretY)
		angle = ATan2(sideY, sideX)
		bullets[currentBullet].x = turretX + GetSpriteWidth(turret)/2
		bullets[currentBullet].y = turretY
		bullets[currentBullet].dx = cos(angle) * 30
		bullets[currentBullet].dy = sin(angle) * 30
		SetSpriteVisible(bullets[currentBullet].sprite, 1)
		bullets[currentBullet].alive = 1
		currentBullet = mod(currentBullet + 1, MAXBULLETS)
		
	endif
	
	turretX = turretX + GetJoystickX() * 30
	SetSpritePosition(turret, turretX, turretY)
	
	if Random(1, enemyFreq) = 1
		if not jets[currentJet].alive
			jets[currentJet].alive = 1
			if jets[currentJet].direction = DIRRIGHT
				jets[currentJet].x = -200
			else
				jets[currentJet].x = 1200
			endif
			jets[currentJet].y = Random(0, 300)
			SetSpritePosition(jets[currentJet].sprite, jets[currentJet].x, jets[currentJet].y)
			SetSpriteVisible(jets[currentJet].sprite, 1)
		endif
		currentJet = mod(currentJet+1, MAXJETS)
	endif
	
	
	for i = 0 to MAXJETS
		if jets[i].alive
			if abs(jets[i].x - turretX) < 42 and not bombs[currentBomb].alive
				bombs[currentBomb].alive = 1
				bombs[currentBomb].x = jets[i].x
				bombs[currentBomb].y = jets[i].y
				SetSpritePosition(bombs[currentBomb].sprite, bombs[currentBomb].x, bombs[currentBomb].y)
				SetSpriteVisible(bombs[currentBomb].sprite, 1)
				
			endif
			jets[i].x = jets[i].x + jets[i].speed
			if (jets[i].x < -150 and jets[i].direction = DIRLEFT) or (jets[i].x > 1074 and jets[i].direction = DIRRIGHT)
				 jets[i].alive = 0
			endif
			SetSpritePosition(jets[i].sprite, jets[i].x, jets[i].y)
		endif
	next i
	
	for i = 0 to MAXBOMBS
		if bombs[i].alive
			if GetSpriteCollision(bombs[i].sprite, turret)
				SetParticlesPosition(particles[currentParticle], bombs[i].x, bombs[i].y)
				SetParticlesActive(particles[currentParticle], 1)
				SetParticlesMax(particles[currentParticle], 100)
				gosub gameover
			elseif bombs[i].y > turretY
				bombs[i].alive = 0
				SetSpriteVisible(bombs[i].sprite, 0)
				SetParticlesPosition(particles[currentParticle], bombs[i].x, bombs[i].y)
				SetParticlesActive(particles[currentParticle], 1)
				SetParticlesMax(particles[currentParticle], 100)
				currentParticle = mod(currentParticle+1, MAXPARTICLES)
			endif
			bombs[i].y = bombs[i].y + bombs[i].speed
			SetSpritePosition(bombs[i].sprite, bombs[i].x, bombs[i].y)
		endif
	next i

	SetSpritePosition(cross, GetPointerX()-GetSpriteWidth(cross)/2, GetPointerY()-GetSpriteHeight(cross)/2)
	
	for i = 0 to MAXBULLETS
		if bullets[i].alive <> 0
			for j = 0 to MAXJETS
				if not jets[j].alive then continue
				if GetSpriteCollision(bullets[i].sprite, jets[j].sprite)
					SetParticlesPosition(particles[currentParticle], bullets[i].x, bullets[i].y)
					SetParticlesActive(particles[currentParticle], 1)
					SetParticlesMax(particles[currentParticle], 100)
					SetSpriteVisible(jets[j].sprite, 0)
					jets[j].alive = 0
					bullets[i].alive = 0
					SetSpriteVisible(bullets[i].sprite, 0)
				endif
			next j

			bullets[i].x = bullets[i].x + bullets[i].dx
			bullets[i].y = bullets[i].y + bullets[i].dy
			SetSpritePosition(bullets[i].sprite, bullets[i].x, bullets[i].y)
			if bullets[i].x < 0 or bullets[i].x > GetVirtualWidth() or bullets[i].y < 0 or bullets[i].y > GetVirtualHeight()
				bullets[i].alive = 0
				bullets[i].x = turretX
				bullets[i].y = turretY
				SetSpriteVisible(bullets[i].sprite, 0)
			endif
		endif

	next i
		
	if GetParticlesMaxReached(particles[currentParticle])
		ResetParticleCount(particles[currentParticle])
		SetParticlesActive(particles[currentParticle], 0)
	endif
	
	currentParticle = mod(currentParticle+1, MAXPARTICLES)
	currentBomb = mod(currentBomb+1, MAXBOMBS)

	sync()
loop

gameover:
SetTextString(t1, "GAME OVER")
SetTextVisible(t1, 1)
SetTextPosition(t1, (GetVirtualWidth()-GetTextTotalWidth(t1))/2, (GetVirtualHeight()-GetTextTotalHeight(t1))/2)
do
	if GetRawKeyPressed(27) then end
	
	sync()
loop	

end
