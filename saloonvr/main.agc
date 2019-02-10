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
	AGKVR.SetPlayerPosition(2, 0, 0)	
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
endtype

type CactiBranch
    branchId as integer
    branchState as integer
endtype



function main()
	
	#insert "makeObjects.agc"

	killedIndex as integer = 0
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
    forest.insert(makeCacti(cactiCoords[killedIndex]))
    /*forest.insert(makeCacti(0.15, 0.8, 10.15))
    forest.insert(makeCacti(4.8, 0.6, 7.32))
    forest.insert(makeCacti(3.0, 0.6, 11))
    forest.insert(makeCacti(-3.16, 0.6, 11))
    forest.insert(makeCacti(3.0, 4.7, 9.99))
    forest.insert(makeCacti(-3.16, 4.7, 10.09))
    forest.insert(makeCacti(0.15, 7.8, 9.75))*/
    
	camSpeed as float = 0.1

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

        if GetPointerPressed()
            objHit = ObjectRayCast(0, camX, camY, camZ, vecX+camX, vecY+camY, vecZ+camZ)
            cactiIndex = findCacti(forest, objHit)
            if cactiIndex <> -1
				oldCactiStatus = forest[cactiIndex].cactiState
				forest[cactiIndex] = killCacti(forest[cactiIndex], objHit)
				newCactiStatus = forest[cactiIndex].cactiState
				if newCactiStatus = 2 and oldCactiStatus <> newCactiStatus
					killedIndex = mod(killedIndex+1, 8)
					forest.insert(makeCacti(cactiCoords[killedIndex]))
				endif
			endif
        endif
		

		//SetObjectRotation(bullet, GetObjectAngleX(gun), GetObjectAngleY(gun), GetObjectAngleZ(gun))
		//RotateObjectLocalY(bullet, -90)
		
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
			
			SetCameraPosition(1, AGKVR.GetHMDX(), AGKVR.GetHMDY(), AGKVR.GetHMDZ())
			SetCameraRotation(1, AGKVR.GetHMDAngleX(), AGKVR.GetHMDAngleY(), AGKVR.GetHMDAngleZ())
			
			if AGKVR.RightControllerFound()
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

				if AGKVR.RightController_Trigger() = 1.0
					isFired = 1
					dragHammerStart = 0
					dragHammerFinish = 0
					SetObjectRotation(hammer, 90, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))	
				endif
				
				bulletStartX = GetObjectX(bullet)
				bulletStartY = GetObjectY(bullet)
				bulletStartZ = GetObjectZ(bullet)
				
				if isFired
					MoveObjectLocalZ(bullet, 1.1)
						
				else
					SetObjectPosition(bullet, GetObjectX(gun), GetObjectY(gun), GetObjectZ(gun))
					SetObjectRotation(bullet, GetObjectAngleX(gun), GetObjectAngleY(gun), GetObjectAngleZ(gun))
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
							killedIndex = mod(killedIndex+1, 8)
							forest.insert(makeCacti(cactiCoords[killedIndex]))
						endif
					endif
				endif
			endif
		
			AGKVR.UpdatePlayer()
			AGKVR.Render()	
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

function findCacti(forest as Cacti[], objHit as integer)
    cactiIndex = -1
    for i = 0 to forest.length
        if objHit >= forest[i].cactiBranches[0].branchId and objHit <= forest[i].cactiBranches[5].branchId then cactiIndex = i
    next i
endfunction (cactiIndex)

function killCacti(c as Cacti, objId as integer)
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
    DeleteObject(b)
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

    c.cactiBranches = branches
endfunction (c)

main()

end

