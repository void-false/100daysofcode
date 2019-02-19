#include "checkinput.agc"
SetErrorMode(2)

// set window properties
SetWindowTitle( "playground" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
//SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetAntialiasMode(1)

Create3DPhysicsWorld(1)
SetSkyBoxVisible(1)

// shadows
SetShadowMappingMode( 3 )
SetShadowSmoothing( 1 ) // random sampling
SetShadowMapSize( 2048, 2048 )
SetShadowRange( 30 ) // use the full camera range
SetShadowBias( 0.0012 ) // offset shadows slightly to avoid shadow artifacts

type Cacti
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

camSpeed as float = 0.1

function main()
	
	SetCameraPosition(1, -4, 1.8, 3)
	SetCameraRange(1, 0.01, 1000)
	SetCameraLookAt(1, -7, 1.3, 10, 0)
	
	ground = CreateObjectBox(100, 1, 100)
	SetObjectColor(ground, 244, 191, 66, 255)
	SetObjectPosition(ground, 0, -0.5, 0)
	Create3DPhysicsKinematicBody(ground)
	SetObject3DPhysicsFriction(ground, 1)
	SetObject3DPhysicsRollingFriction(ground, 1)
	SetObjectReceiveShadow(ground, 1)
	SetObjectLightMode(ground, 1)

	vecX as float
    vecY as float
    vecZ as float
    camX as float
    camY as float
    camZ as float
    forest as Cacti[]
    forest.insert(makeCacti(-6, 0.6, 7))
	/*for i = 0 to 10
		forest.insert(makeCacti(Random(0, 10)*-1, 0.6, Random(7, 30)))
    next i*/
    
    
    c1 as Cacti : c1 = forest[0]
	do
		if GetRawKeyPressed(27) then exit
		if GetRawKeyPressed(asc(" "))
			muzzleFlash(c1.cactiGunId)
		endif
		vecX = Get3DVectorXFromScreen(GetPointerX(), GetPointerY()) * 800
        vecY = Get3DVectorYFromScreen(GetPointerX(), GetPointerY()) * 800
        vecZ = Get3DVectorZFromScreen(GetPointerX(), GetPointerY()) * 800
        camX = GetCameraX(1)
        camY = GetCameraY(1)
        camZ = GetCameraZ(1)

        if GetPointerPressed()
            objHit = ObjectRayCast(0, camX, camY, camZ, vecX+camX, vecY+camY, vecZ+camZ)
            cactiIndex = findCacti(forest, objHit)
            if cactiIndex <> -1 then forest[cactiIndex] = killCacti(forest[cactiIndex], objHit)
        endif
		gosub checkInput
		if not c1.isShooting and (Timer() - c1.timeCreated > 1.0)
			muzzleFlash(c1.cactiGunId) 
			c1.isShooting = 1
			shotCooldown as float : shotCooldown = Timer()
		endif
		if c1.isShooting and Timer() - shotCooldown > 0.5 then c1.isShooting = 0
		Step3DPhysicsWorld()
		Sync()
	loop
	
endfunction

function muzzleFlash(b as integer)
	p = Create3DParticles(GetObjectX(b), GetObjectY(b), GetObjectZ(b))
	Set3DParticlesPosition(p, GetObjectX(b), GetObjectY(b)+0.12, GetObjectZ(b)-0.56)
	Set3DParticlesImage(p, CreateImageColor(255, 255, 255, 255))	
	Set3DParticlesLife(p, 0.1)
	Set3DParticlesSize(p, 0.04)
	Set3DParticlesDirection(p, 0, 1.5, 0, 0)
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
	currentBranchIndex = c.cactiBranches.find(objId)
	makeSplatter(objId)
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

function makeCacti(x as float, y as float, z as float)
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


main()

end
