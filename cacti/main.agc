#include "checkinput.agc"
SetErrorMode(2)

// set window properties
SetWindowTitle( "playground" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Create3DPhysicsWorld(1)
SetSkyBoxVisible(1)

type Cacti
	cactiState as integer
	cactiBranches as cactiBranch[6]
endtype

type CactiBranch
	branchId as integer
	branchState as integer
endtype

camSpeed as float = 0.1

function main()
	
	SetCameraPosition(1, -4, 1.8, -1)
	SetCameraLookAt(1, -6, 1.3, 10, 0)
	
	ground = CreateObjectBox(100, 1, 100)
	SetObjectColor(ground, 244, 191, 66, 255)
	SetObjectPosition(ground, 0, -0.5, 0)
	Create3DPhysicsKinematicBody(ground)
	SetObject3DPhysicsFriction(ground, 1)
	SetObject3DPhysicsRollingFriction(ground, 1)

	c1 as Cacti
	c1 = makeCacti(-6, 0.6, 7)
	objId as integer = 100006              
	do
		if GetRawKeyPressed(27) then exit
		//if GetRawKeyPressed(asc(" ")) then c1 = killCacti(c1, objId)
		if GetRawKeyPressed(asc("0")) then c1 = killCacti(c1, 100002)
		if GetRawKeyPressed(asc("1")) then c1 = killCacti(c1, 100003)
		if GetRawKeyPressed(asc("2")) then c1 = killCacti(c1, 100004)
		if GetRawKeyPressed(asc("3")) then c1 = killCacti(c1, 100005)
		if GetRawKeyPressed(asc("4")) then c1 = killCacti(c1, 100006)
		if GetRawKeyPressed(asc("5")) then c1 = killCacti(c1, 100007)
		
		gosub checkInput
		Step3DPhysicsWorld()
		Sync()
	loop
	
endfunction

function killCacti(c as Cacti, objId as integer)
	currentBranchIndex = c.cactiBranches.find(objId)
	Print(currentBranchIndex)
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
	next i
	DeleteObject(b)
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
	
	c.cactiBranches = branches
endfunction (c)



main()

end
