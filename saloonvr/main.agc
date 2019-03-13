SetErrorMode(2)

#import_plugin AGKVR

SetWindowTitle("Saloon VR")
SetVirtualResolution( 1024, 768 )
SetClearColor( 101, 120, 154 )
SetScissor( 0,0,0,0 )
SetGenerateMipmaps( 1 )
SetCameraRange( 1, 0.1, 100 )
SetWindowAllowResize( 1 )
SetAntialiasMode(1)

if AGKVR.IsHmdPresent()
	SetSyncRate(0, 0)
	AGKVR.SetCameraRange(0.01, 1000.0)
	initError as integer
	initError = AGKVR.Init(500, 501)
	//AGKVR.SetPlayerPosition(1.5, 0, 0)	
	AGKVR.SetPlayerPosition(0, 0, 0)	
	AGKVR.LockPlayerTurn( 1 )
	AGKVR.LockPlayerPitch( 0 )	
endif
	
Create3DPhysicsWorld(1)
SetSkyBoxVisible(1)

// shadows 
SetShadowMappingMode( 3 )
SetShadowSmoothing( 1 ) // random sampling
SetShadowMapSize( 2048, 2048 )
SetShadowRange( 30 ) // use the full camera range
SetShadowBias( 0.0012 ) // offset shadows slightly to avoid shadow artifacts

type Cacti
	cactiId as integer
    cactiState as integer
    cactiBranches as cactiBranch[6]
	cactiGunId as integer
	timeCreated as float
	isShooting as integer
endtype

type CactiBranch
    branchId as integer
    branchState as integer
endtype

function main()
	
	#insert "makeObjects.agc"
	#constant STATEMAINMENU = 0
	#constant STATEPLAYING = 1
	#constant STATEGAMEOVER = 2
	
	gameState as integer = STATEMAINMENU
	positionIndex as integer : positionIndex = Random(0, 7)
	positionIndexOld as integer : positionIndexOld = positionIndex
	isFired as integer = 0
	isBulletMoving as integer = 0
	speed as float = 5.0
	dragHammerStart as integer = 0
	dragHammerFinish as integer = 0

	bulletStartX as float
	bulletStartY as float
	bulletStartZ as float
	bulletEndX as float
	bulletEndY as float
	bulletEndZ as float

	SetCameraPosition(1, 0, 1.86, -5)
	SetCameraRange(1, 0.01, 1000)
	SetCameraLookAt(1, 0.15, 2.8, 10.15, 0)

    vecX as float
    vecY as float
    vecZ as float
    camX as float
    camY as float
    camZ as float

    cactiCoords as float[7,2]
	cactiCoords[0] = [-6, 0.6, 7]
	cactiCoords[1] = [0.15, 0.8, 10.15]
	cactiCoords[2] = [4.8, 0.6, 7.32]
	cactiCoords[3] = [3.0, 0.6, 11]
	cactiCoords[4] = [-3.16, 0.6, 11]
	cactiCoords[5] = [3.0, 4.6, 9.99]
	cactiCoords[6] = [-3.16, 4.6, 10.09]
	cactiCoords[7] = [0.15, 7.8, 9.75]

    forest as Cacti[]
    
	camSpeed as float = 0.1
	killedTime as float
	timeToWait as float = 2.0
	timeSinceEnemyWaits as float
	createNewEnemy as integer = 1
	isEnemyOnScreen as integer = 0
	difficulty as float = 1.0
	enemiesKilled as integer = 0
	playerAlive as integer = 1
	triggerUnplressed as integer = 0
	deathDelay as float = 1.0
	playerKilledTime as float
	
	menuObject as integer[]
	menuObject.insert(mainMenu)
	menuObject.insert(buttonPlay)
	menuObject.insert(buttonHelp)
	menuObject.insert(buttonExit)
	
	shaderEndTime as float = 0.0
	renderImage as integer : renderImage = CreateRenderImage(GetImageWidth(500), GetImageHeight(500), 0, 0)
	shaderBW as integer : shaderBW = LoadFullScreenShader("Luminance.ps")
	shaderDefault as integer : shaderDefault = LoadFullScreenShader("Default.ps")
	shaderCurrent as integer : shaderCurrent = shaderDefault
	
	do
		if GetRawKeyPressed(27) then exit
		
		if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, camSpeed)
		if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -camSpeed)
		if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -camSpeed)
		if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, camSpeed)
		if GetRawKeyState(asc("Q")) and not GetRawKeyState(16) then MoveCameraLocalY(1, camSpeed)
		if GetRawKeyState(asc("Z")) and not GetRawKeyState(16) then MoveCameraLocalY(1, -camSpeed)
		
		if GetRawKeyState(16) and GetRawKeyState(asc("W")) then RotateObjectLocalX(gun, -1)
		if GetRawKeyState(16) and GetRawKeyState(asc("S")) then RotateObjectLocalX(gun, 1)
		if GetRawKeyState(16) and GetRawKeyState(asc("A")) then RotateObjectLocalY(gun, -1)
		if GetRawKeyState(16) and GetRawKeyState(asc("D")) then RotateObjectLocalY(gun, 1)
		if GetRawKeyState(16) and GetRawKeyState(asc("Q")) then RotateObjectLocalZ(gun, 1)
		if GetRawKeyState(16) and GetRawKeyState(asc("Z")) then RotateObjectLocalZ(gun, -1)
		
		vecX = Get3DVectorXFromScreen(GetPointerX(), GetPointerY()) * 800
		vecY = Get3DVectorYFromScreen(GetPointerX(), GetPointerY()) * 800
		vecZ = Get3DVectorZFromScreen(GetPointerX(), GetPointerY()) * 800
		camX = GetCameraX(1)
		camY = GetCameraY(1)
		camZ = GetCameraZ(1)
		
		if gameState = STATEMAINMENU
			if GetPointerPressed()
				objHit = ObjectRayCast(0, camX, camY, CamZ, vecX+camX, vecY+camY, vecZ+camZ)		
				buttonPressed = checkMenuButtons(buttonPlay, buttonHelp, buttonExit, objHit)
				if buttonPressed = 1
					gameState = STATEPLAYING
					hideMenu(menuObject)
					ResetTimer()
				endif
			endif

		elseif gameState = STATEGAMEOVER
			if Timer() - playerKilledTime > deathDelay
				showGameOver(gameOver)
				showMenu(menuObject)
			endif
			if GetPointerPressed()
				objHit = ObjectRayCast(0, camX, camY, CamZ, vecX+camX, vecY+camY, vecZ+camZ)		
				buttonPressed = checkMenuButtons(buttonPlay, buttonHelp, buttonExit, objHit)
				if buttonPressed = 1
					hideMenu(menuObject)
					hideGameOver(gameOver)
					forest.length = -1
					clearScene(menuObject[menuObject.length]+1)
					killedTime = 0.0
					timeToWait = 2.0
					timeSinceEnemyWaits = 0.0
					createNewEnemy = 1
					isEnemyOnScreen = 0
					difficulty = 1.0
					enemiesKilled = 0
					playerAlive = 1
					gameState = STATEPLAYING
					ResetTimer()
				endif
			endif
	
		elseif gameState = STATEPLAYING
			hideGameOver(gameOver)
			shaderCurrent = shaderDefault
			Delete3DPhysicsBody(gun)
			if GetPointerPressed()
				objHit = ObjectRayCast(0, camX, camY, camZ, vecX+camX, vecY+camY, vecZ+camZ)
				cactiIndex = findCacti(forest, objHit)
				if cactiIndex <> -1
					oldCactiStatus = forest[cactiIndex].cactiState
					forest[cactiIndex] = killCacti(forest[cactiIndex], objHit)
					newCactiStatus = forest[cactiIndex].cactiState
					if newCactiStatus = 2 and oldCactiStatus <> newCactiStatus
						isEnemyOnScreen = 0
						killedTime = Timer()
						difficulty = difficulty + 0.1
						createNewEnemy = 1
						timeToWait = 2.0 / difficulty	
					endif
				endif
			endif
			
			if createNewEnemy and Timer() - killedTime > timeToWait
				createNewEnemy = 0
				positionIndex = Random(0, 7)
				forest.insert(makeCacti(cactiCoords[positionIndex]))
				enemiesKilled = enemiesKilled + 1
				isEnemyOnScreen = 1
				//timeSinceEnemyWaits = Timer()
			endif
			
			if playerAlive and isEnemyOnScreen 
				cc as Cacti : cc = forest[forest.length]
				if Timer() - cc.timeCreated > timeToWait and cc.cactiState <> 2 and not cc.isShooting
					muzzleFlashCacti(cc.cactiGunId)
					Create3DPhysicsDynamicBody(gun)
					forest[forest.length].isShooting = 1
					enemyCooldown as float : enemyCooldown = Timer()
					playerAlive = 0		
					shaderCurrent = shaderBW
					shaderEndTime = Timer() + 1.5	
				endif
				if Timer() - enemyCooldown > 0.5 then forest[forest.length].isShooting = 0
				//killPlayer(forest[cactiIndex])
				//playerAlive = 0
			endif
			
			if not playerAlive
				playerKilledTime = Timer()
				gameState = STATEGAMEOVER
			endif
			//SetObjectRotation(bullet, GetObjectAngleX(gun), GetObjectAngleY(gun), GetObjectAngleZ(gun))
			//RotateObjectLocalY(bullet, -90)
		endif
		if GetRawKeyState(asc(" ")) 
			MoveObjectLocalX(bullet, 0.01)
		elseif GetRawKeyReleased(asc(" "))
			SetObjectPosition(bullet, GetObjectX(gun), GetObjectY(gun), GetObjectZ(gun))
		endif
		
		if GetRawKeyPressed(asc("R")) then SetObjectRotation(gun, 0, 0, 0)
		
		if GetRawMouseRightPressed()
			startx# = GetPointerX()
			starty# = GetPointerY()
			angx# = GetCameraAngleX(1)
			angy# = GetCameraAngleY(1)
		endif
		if GetRawMouseRightState()
			fDiffX# = (GetPointerX() - startx#)/2.0
			fDiffY# = (GetPointerY() - starty#)/2.0
			SetCameraRotation( 1, angx# + fDiffY#, angy# + fDiffX#, 0 )
		endif
		
		if AGKVR.IsHMDPresent()
			
			if GetRawKeyState(asc("W")) then AGKVR.MovePlayerLocalZ(0.06)
			if GetRawKeyState(asc("S")) then AGKVR.MovePlayerLocalZ(-0.06)
			if GetRawKeyState(asc("A")) then AGKVR.MovePlayerLocalX(-0.06)
			if GetRawKeyState(asc("D")) then AGKVR.MovePlayerLocalX(0.06)
			if GetRawKeyState(asc("R")) then moveMenuY(menuObject, 0.01)
			if GetRawKeyState(asc("T")) then moveMenuY(menuObject, -0.01)
			
			SetCameraPosition(1, AGKVR.GetHMDX(), AGKVR.GetHMDY(), AGKVR.GetHMDZ())
			SetCameraRotation(1, AGKVR.GetHMDAngleX(), AGKVR.GetHMDAngleY(), AGKVR.GetHMDAngleZ())
			
			if AGKVR.RightControllerFound()
				if gameState = STATEMAINMENU
					SetObjectPosition(pointer, AGKVR.GetRightHandX(), AGKVR.GetRightHandY(), AGKVR.GetRightHandZ())
					SetObjectRotation(pointer, AGKVR.GetRightHandAngleX(), AGKVR.GetRightHandAngleY(), AGKVR.GetRightHandAngleZ())
					RotateObjectLocalX(pointer, 60)
					if AGKVR.RightController_Trigger() = 1.0
						SetObjectPosition(pointB, GetObjectX(pointer), GetObjectY(pointer), GetObjectZ(pointer))
						SetObjectRotation(pointB, GetObjectAngleX(pointer), GetObjectAngleY(pointer), GetObjectAngleZ(pointer)) 
						MoveObjectLocalZ(pointB, 2)
						objHit = ObjectRayCast(0, GetObjectX(pointer), GetObjectY(pointer), GetObjectZ(pointer), GetObjectX(pointB), GetObjectY(pointB), GetObjectZ(pointB))
						buttonPressed = checkMenuButtons(buttonPlay, buttonHelp, buttonExit, objHit)
						if buttonPressed = 1
							gameState = STATEPLAYING
							hideMenu(menuObject)
							SetObjectVisible(pointer, 0)
							ResetTimer()
						endif
					endif
				elseif gameState = STATEGAMEOVER
					triggerUnplressed = 0
					SetObjectPosition(gameOver, AGKVR.GetHMDX(), AGKVR.GetHMDY(), AGKVR.GetHMDZ())
					SetObjectRotation(gameOver, AGKVR.GetHMDAngleX(), AGKVR.GetHMDAngleY(), AGKVR.GetHMDAngleZ())
					MoveObjectLocalZ(gameOver, 0.75)
					//MoveObjectLocalX(gameOver, 0.15)
					MoveObjectLocalY(gameOver, 0.3)
					//RotateObjectLocalX(gameOver, 15)
					//RotateObjectLocalY(gameOver, 15)
					SetObjectVisible(pointer, 1)
					SetObjectPosition(pointer, AGKVR.GetRightHandX(), AGKVR.GetRightHandY(), AGKVR.GetRightHandZ())
					SetObjectRotation(pointer, AGKVR.GetRightHandAngleX(), AGKVR.GetRightHandAngleY(), AGKVR.GetRightHandAngleZ())
					RotateObjectLocalX(pointer, 60)
					if AGKVR.RightController_Trigger() = 1.0
						SetObjectPosition(pointB, GetObjectX(pointer), GetObjectY(pointer), GetObjectZ(pointer))
						SetObjectRotation(pointB, GetObjectAngleX(pointer), GetObjectAngleY(pointer), GetObjectAngleZ(pointer)) 
						MoveObjectLocalZ(pointB, 2)
						objHit = ObjectRayCast(0, GetObjectX(pointer), GetObjectY(pointer), GetObjectZ(pointer), GetObjectX(pointB), GetObjectY(pointB), GetObjectZ(pointB))
						buttonPressed = checkMenuButtons(buttonPlay, buttonHelp, buttonExit, objHit)
						if buttonPressed = 1
							gameState = STATEPLAYING
							hideMenu(menuObject)
							SetObjectRotation(hammer, 0, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))
							isFired = 0
							isBulletMoving = 0
							dragHammerStart = 0
							dragHammerFinish = 0
							forest.length = -1
							clearScene(menuObject[menuObject.length]+1)
							killedTime = 0.0
							timeToWait = 2.0
							timeSinceEnemyWaits = 0.0
							createNewEnemy = 1
							isEnemyOnScreen = 0
							difficulty = 1.0
							enemiesKilled = 0
							playerAlive = 1
							SetObjectVisible(pointer, 0)
							ResetTimer()
						endif
					endif
				elseif gameState = STATEPLAYING
					if AGKVR.RightController_Trigger() < 0.5 then triggerUnplressed = 1
					SetObjectPosition(gun, AGKVR.GetRightHandX(), AGKVR.GetRightHandY(), AGKVR.GetRightHandZ())
					SetObjectRotation(gun, AGKVR.GetRightHandAngleX(), AGKVR.GetRightHandAngleY(), AGKVR.GetRightHandAngleZ())
					RotateObjectLocalX(gun, 60)
					
					SetObjectRotation(trigger, 45+AGKVR.RightController_Trigger()*45, GetObjectAngleY(trigger), GetObjectAngleZ(trigger))
					
					if isFired and not dragHammerStart and AGKVR.RightController_JoyY() > 0.8
						dragHammerStart = 1
					endif
					
					if dragHammerStart and not dragHammerFinish
						//SetObjectRotation(hammer, (AGKVR.RightController_JoyY()+1)*45, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))
						SetObjectRotation(hammer, AGKVR.RightController_JoyY()*90, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))
					endif
					
					if dragHammerStart and AGKVR.RightController_JoyY() = 0
						dragHammerStart = 0
						SetObjectRotation(hammer, 90, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))		
					endif
					
					if dragHammerStart and AGKVR.RightController_JoyY() < 0.0
						SetObjectRotation(hammer, 0, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))
						isFired = 0
						dragHammerFinish = 1
						dragHammerStart = 0
					endif

					if AGKVR.RightController_Trigger() = 1.0 and triggerUnplressed
						isFired = 1
						dragHammerStart = 0
						dragHammerFinish = 0
						SetObjectRotation(hammer, 90, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))	
						muzzleFlash(bullet)
					endif
					
					bulletStartX = GetObjectX(bullet)
					bulletStartY = GetObjectY(bullet)
					bulletStartZ = GetObjectZ(bullet)
					
					if isFired
						MoveObjectLocalZ(bullet, 1.1)
							
					else
						SetObjectRotation(bullet, GetObjectAngleX(gun), GetObjectAngleY(gun), GetObjectAngleZ(gun))
						SetObjectPosition(bullet, GetObjectX(gun), GetObjectY(gun), GetObjectZ(gun))
						MoveObjectLocalZ(bullet, 0.3)
						MoveObjectLocalY(bullet, 0.04)
					endif
					
					bulletEndX = GetObjectX(bullet)
					bulletEndY = GetObjectY(bullet)
					bulletEndZ = GetObjectZ(bullet)
					
					objHit = ObjectSphereSlide(0, bulletStartX, bulletStartY, bulletStartZ, bulletEndX, bulletEndY, bulletEndZ, 0.011)
					if objHit <> 0
						cactiIndex = findCacti(forest, objHit)
						if cactiIndex <> -1
							oldCactiStatus = forest[cactiIndex].cactiState
							forest[cactiIndex] = killCacti(forest[cactiIndex], objHit)
							newCactiStatus = forest[cactiIndex].cactiState
							if newCactiStatus = 2 and oldCactiStatus <> newCactiStatus
								killedTime = Timer()
								difficulty = difficulty + 0.1
								createNewEnemy = 1
								timeToWait = 2.0 / difficulty	
							endif
						endif
					endif
				endif
			endif
			
	
			Update(0)
			AGKVR.UpdatePlayer()
			AGKVR.SetCameraToRightEye()
			SetRenderToImage(renderImage, -1)
			ClearScreen()
			Render()
			SetObjectImage(quad, renderImage, 0)
			SetShaderConstantByName(shaderBW, "endTime", shaderEndTime, 0, 0, 0)
			SetObjectShader(quad, shaderCurrent)
			SetRenderToImage(500, 0)
			DrawObject(quad)
			AGKVR.SubmitRightEye()
			//AGKVR.Render()	
			AGKVR.SetCameraToLeftEye()
			SetRenderToImage(renderImage, -1)
			ClearScreen()
			Render()
			SetObjectImage(quad, renderImage, 0)
			SetShaderConstantByName(shaderBW, "endTime", shaderEndTime, 0, 0, 0)
			SetObjectShader(quad, shaderCurrent)
			SetRenderToImage(501, 0)
			DrawObject(quad)
			AGKVR.SubmitLeftEye()
			SetRenderToScreen()
		endif
			
			
			/*if isBulletMoving
				MoveObjectLocalX(bullet, cos(AGKVR.GetRightHandAngleX())/100.0)
				MoveObjectLocalZ(bullet, sin(AGKVR.GetRightHandAngleZ())/100.0)
			endif
			
			if isFired = 1 and AGKVR.RightController_Trigger() = 0
				isFired = 0
			endif
			
			if isFired = 0 and AGKVR.RightController_Trigger() = 1
				AGKVR.RightController_TriggerPulse(0, 1000)
				isFired = 1
				isBulletMoving = 1
				RotateObjectLocalX(gun, -15)
			endif*/
		
		Step3DPhysicsWorld()
		Sync()
	loop
endfunction

function moveMenuY(menuObject as integer[], dy as float)
	for i = 0 to menuObject.length
		obj = menuObject[i]
		SetObjectPosition(obj, GetObjectX(obj), GetObjectY(obj) + dy, GetObjectZ(obj))
	next i
endfunction

function showGameOver(gameOver as integer)
	SetObjectVisible(gameOver, 1)
endfunction

function hideGameOver(gameOver as integer)
	SetObjectVisible(gameOver, 0)
endfunction

function killPlayer(c ref as Cacti)
	for i = 0 to c.cactiBranches.length-1
		currentBranch = c.cactiBranches[i].branchId
		if GetObjectExists(currentBranch) and c.cactiBranches[i].branchState = 0 then SetObjectColor(currentBranch, 255, 0, 0, 255)
	next i
endfunction

function muzzleFlash(b as integer)
	p = Create3DParticles(GetObjectX(b), GetObjectY(b), GetObjectZ(b))
	Set3DParticlesPosition(p, GetObjectX(b), GetObjectY(b), GetObjectZ(b))
	Set3DParticlesImage(p, CreateImageColor(255, 255, 255, 255))	
	Set3DParticlesLife(p, 0.1)
	Set3DParticlesSize(p, 0.02)
	Set3DParticlesDirection(p, 0, 0.7, 0, 0)
	Set3DParticlesDirectionRange(p, 360, 0)
	Set3DParticlesMax(p, 50)
	Set3DParticlesFrequency(p, 10000)
	Add3DParticlesColorKeyFrame(p, 0.0, 252, 254, 253, 255)
	Add3DParticlesColorKeyFrame(p, 0.1, 247, 111, 5, 255)
endfunction

function muzzleFlashCacti(b as integer)
	p = Create3DParticles(GetObjectX(b), GetObjectY(b), GetObjectZ(b))
	Set3DParticlesPosition(p, GetObjectX(b), GetObjectY(b)+0.12, GetObjectZ(b)-0.56)
	Set3DParticlesImage(p, CreateImageColor(255, 255, 255, 255))	
	Set3DParticlesLife(p, 0.1)
	Set3DParticlesSize(p, 0.07)
	Set3DParticlesDirection(p, 0, 2.5, 0, 0)
	Set3DParticlesDirectionRange(p, 360, 0)
	Set3DParticlesMax(p, 50)
	Set3DParticlesFrequency(p, 10000)
	Add3DParticlesColorKeyFrame(p, 0.0, 252, 254, 253, 255)
	Add3DParticlesColorKeyFrame(p, 0.1, 247, 111, 5, 255)
endfunction

function findCacti(forest as Cacti[], objHit as integer)
    cactiIndex = -1
    for i = 0 to forest.length
        if objHit >= forest[i].cactiBranches[0].branchId and objHit <= forest[i].cactiBranches[5].branchId then cactiIndex = i
    next i
endfunction (cactiIndex)

function killCacti(c as Cacti, objId as integer)
	makeSplatter(objId)
    currentBranchIndex = c.cactiBranches.find(objId)
    if c.cactiBranches[currentBranchIndex].branchState = 1
        killCactiBranch(objId)
        exitfunction (c)
    endif
    branches as CactiBranch[5]
    branches = c.cactiBranches
    if (c.cactiState = 0) and (objId = branches[0].branchId or objId = branches[2].branchId or objId = branches[3].branchId)
        for i = 0 to 5
            Create3DPhysicsDynamicBody(branches[i].branchId)
            SetObjectShapeCapsule(branches[i].branchId, 1)
            if i = 2 or i = 4 then SetObjectShapeCapsule(branches[i].branchId, 0)
            setFrictionAndVelocity(branches[i].branchId)
            branches[i].branchState = 1
        next i
        c.cactiState = 2
    elseif (c.cactiState = 0) and (objId = branches[1].branchId or objId = branches[4].branchId or objId = branches[5].branchId)
        indexi as integer[3] = [1, 4, 5]
        for i = 0 to 2
            Create3DPhysicsDynamicBody(branches[indexi[i]].branchId)
            SetObjectShapeCapsule(branches[indexi[i]].branchId, 1)
            if i = 1 then SetObjectShapeCapsule(branches[indexi[i]].branchId, 0)
            setFrictionAndVelocity(branches[indexi[i]].branchId)
            branches[indexi[i]].branchState = 1
        next i
        c.cactiState = 1
    elseif c.cactiState = 1
        indexi = [0, 2, 3]
        for i = 0 to 2
            Create3DPhysicsDynamicBody(branches[indexi[i]].branchId)
            SetObjectShapeCapsule(branches[indexi[i]].branchId, 1)
            if i = 1 then SetObjectShapeCapsule(branches[indexi[i]].branchId, 0)
            setFrictionAndVelocity(branches[indexi[i]].branchId)
            branches[indexi[i]].branchState = 1
        next i
        c.cactiState = 2
    endif
	if c.cactiState = 2 then Create3DPhysicsDynamicBody(c.cactiGunId) 
    c.cactiBranches = branches
endfunction (c)

function setFrictionAndVelocity(obj as integer)
    SetObject3DPhysicsLinearVelocity(obj, -1, 1, RandomSign(1), 1)
    SetObject3DPhysicsAngularVelocity(obj, Random(-180, 180), Random(-180, 180), Random(-180, 180), 20)
    SetObject3DPhysicsFriction(obj, 0.2)
    SetObject3DPhysicsRollingFriction(obj, 0.1)
endfunction

function killCactiBranch(b as integer)
    i as float
    dw as float : dh as float : dl as float

    for i = -0.2 to 0.2 step 0.1
        dw = Random(10, 20) / 100.0
        dh = Random(30, 60) / 100.0
        dl = Random(5, 10) / 100.0
        debris = CreateObjectBox(dw, dh, dl)
        SetObjectColor(debris, 0, 255, 0, 255)
        SetObjectPosition(debris, GetObjectX(b)+i, GetObjectY(b)+i, GetObjectZ(b)+i)
        Create3DPhysicsDynamicBody(debris)
        SetObject3DPhysicsAngularVelocity(debris, Random(-180, 180), Random(-180, 180), Random(-180, 180), 10)
        SetObject3DPhysicsLinearVelocity(debris, i*2, 1, 0, 5)
        SetObjectCastShadow(debris, 1)
    next i
    makeSplatter(b)
    DeleteObject(b)
endfunction

function makeSplatter(b as integer)
	for i = 0 to 1
		p = Create3DParticles(GetObjectX(b), GetObjectY(b), GetObjectZ(b))
		//Set3DParticlesImage(p, LoadImage("splatter.png"))
		//Set3DParticlesImage(p, CreateImageColor(28, 165, 113, 255))	
		Set3DParticlesImage(p, CreateImageColor(220,20,60, 255))	
		Set3DParticlesLife(p, 0.5)
		Set3DParticlesSize(p, 0.04)
		Set3DParticlesDirection(p, 0, 7, 0, 0)
		Set3DParticlesDirectionRange(p, 360, 180)
		Set3DParticlesMax(p, 100)
		Set3DParticlesFrequency(p, 100000)
		Add3DParticlesForce(p, 0.1, 1, 0, -70, 0)
	next i
endfunction

function makeCacti(coords as float[])
    x as float, y as float, z as float
    x = coords[0] : y = coords[1] : z = coords[2]
    c as Cacti
    branches as CactiBranch[6]

    branches[0].branchId = CreateObjectCapsule(0.5, 1.2, 1)
    SetObjectPosition(branches[0].branchId, x, y, z)

    branches[1].branchId = CreateObjectCapsule(0.5, 1.2, 1)
    SetObjectPosition(branches[1].branchId, GetObjectX(branches[0].branchId), GetObjectY(branches[0].branchId)+1, GetObjectZ(branches[0].branchId))

    branches[2].branchId = CreateObjectCapsule(0.3, 0.7, 0)
    SetObjectPosition(branches[2].branchId, GetObjectX(branches[0].branchId)+0.4, GetObjectY(branches[0].branchId), GetObjectZ(branches[0].branchId))

    branches[3].branchId = CreateObjectCapsule(0.3, 1.1, 1)
    SetObjectPosition(branches[3].branchId, GetObjectX(branches[2].branchId)+0.25, GetObjectY(branches[2].branchId)+0.45, GetObjectZ(branches[2].branchId))

    branches[4].branchId = CreateObjectCapsule(0.2, 0.7, 0)
    SetObjectPosition(branches[4].branchId, GetObjectX(branches[1].branchId)-0.25, GetObjectY(branches[1].branchId), GetObjectZ(branches[1].branchId))

    branches[5].branchId = CreateObjectCapsule(0.2, 0.9, 1)
    SetObjectPosition(branches[5].branchId, GetObjectX(branches[4].branchId)-0.25, GetObjectY(branches[4].branchId)+0.35, GetObjectZ(branches[4].branchId))

    for i = 0 to 5
        SetObjectColor(branches[i].branchId, 58, 224, 49, 255)
        SetObjectCastShadow(branches[i].branchId, 1)
    next i

	c.timeCreated = Timer()
	c.cactiGunId = makeCactiGun(branches[0].branchId)
    c.cactiBranches = branches
endfunction (c)

function makeCactiGun(rootBranch as integer)
	gun = CreateObjectBox(0.04, 0.2, 0.1)
	SetObjectPosition(gun, 0, 0, 0)
	RotateObjectLocalX(gun, 15)
	FixObjectPivot(gun)

	body = CreateObjectBox(0.04, 0.1, 0.2)
	SetObjectPosition(body, 0, 0.1, 0.07)

	drum = CreateObjectCylinder(0.12, 0.10, 6)
	RotateObjectLocalX(drum, 90)
	SetObjectPosition(drum, 0, 0.1, 0.09)

	barrel = CreateObjectCylinder(0.4, 0.04, 10)
	RotateObjectLocalX(barrel, 90)
	SetObjectPosition(barrel, 0, 0.12, 0.34)

	gunParts as integer[]
	gunparts.insert(gun)
	gunparts.insert(body)
	gunparts.insert(drum)
	gunparts.insert(barrel)
	
	for i = 0 to gunParts.length
		SetObjectColor(gunParts[i], 63, 61, 62, 255)
		SetObjectCastShadow(gunParts[i], 1)
		if i <> 0 then FixObjectToObject(gunParts[i], gun)
	next i
	
	SetObjectPosition(gun, GetObjectX(rootBranch)+0.7, GetObjectY(rootBranch)+1, GetObjectZ(rootBranch)-0.1)
    RotateObjectLocalY(gun, 180)

endfunction (gun)

function checkMenuButtons(buttonPlay as integer, buttonHelp as integer, buttonExit as integer, objHit as integer)
	buttonPressed = -1
	if objHit = buttonPlay
		buttonPressed = 1
	elseif objHit = buttonHelp
		SetObjectPosition(buttonHelp, GetObjectX(buttonHelp), GetObjectY(buttonHelp), 1.483)
	elseif objHit = buttonExit
		
		end
	endif
	/*if objHit = buttonPlay then SetObjectPosition(buttonPlay, GetObjectX(buttonPlay), GetObjectY(buttonPlay), 1.483)
	if GetRawKeyReleased(asc("1")) then SetObjectPosition(buttonPlay, GetObjectX(buttonPlay), GetObjectY(buttonPlay), 1.45)
	if GetRawKeyState(asc("2")) then SetObjectPosition(buttonHelp, GetObjectX(buttonHelp), GetObjectY(buttonHelp), 1.483)
	if GetRawKeyReleased(asc("2")) then SetObjectPosition(buttonHelp, GetObjectX(buttonHelp), GetObjectY(buttonHelp), 1.45)
	if GetRawKeyState(asc("3")) then SetObjectPosition(buttonExit, GetObjectX(buttonExit), GetObjectY(buttonExit), 1.483)
	if GetRawKeyReleased(asc("3")) then SetObjectPosition(buttonExit, GetObjectX(buttonExit), GetObjectY(buttonExit), 1.45)*/
	
endfunction(buttonPressed)

function hideMenu(menuObject as integer[])
	for i = 0 to menuObject.length
		SetObjectVisible(menuObject[i], 0)
		SetObjectCollisionMode(menuObject[i], 0)
	next i
endfunction

function showMenu(menuObject as integer[])
	for i = 0 to menuObject.length
		SetObjectVisible(menuObject[i], 1)
		SetObjectCollisionMode(menuObject[i], 1)
	next i
endfunction

function clearScene(startObjectId as integer)
	lastObjectId = startObjectId + 10000
	for i = startObjectId to lastObjectId 
		DeleteObject(i)
	next i
		
endfunction

main()

end

