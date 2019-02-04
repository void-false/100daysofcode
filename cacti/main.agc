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

type Cacti
	cactiState as integer
	cactiBranches as cactiBranch[6]
endtype

type CactiBranch
	branchId as integer
endtype

function main()
	
	SetCameraPosition(1, -4, 1.8, -1)
	SetCameraLookAt(1, -5, 1.3, 10, 0)
	
	ground = CreateObjectBox(100, 0, 100)
	SetObjectColor(ground, 244, 191, 66, 255)
	SetObjectPosition(ground, 0, 0, 0)
	Create3DPhysicsKinematicBody(ground)

	c1 as Cacti
	c1 = makeCacti(-6, 0.6, 7)
	
	c2 as Cacti
	c2 = makeCacti(-3, 0.6, 7)

	debris as integer[5]
	killed as integer = 0

	do
		if GetRawKeyPressed(27) then exit
		
		if GetRawKeyPressed(asc(" ")) then c1.cactiState = killCacti(c1)
		
		if c1.cactiState = 1
			for i = 0 to 5
				Print(GetObject3DPhysicsAngularVelocityX(c1.cactiBranches[i].branchId))
			next i
		endif
		Step3DPhysicsWorld()
		Sync()
	loop
	
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

function killCacti(c as Cacti)
	if c.cactiState = 0
		branches as CactiBranch[5]
		branches = c.cactiBranches
		for i = 0 to 5	
			Create3DPhysicsDynamicBody(branches[i].branchId)
			SetObjectShapeCapsule(branches[i].branchId, 0)
			SetObject3DPhysicsFriction(branches[i].branchId, 1)
			SetObject3DPhysicsLinearVelocity(branches[i].branchId, -1, 1, RandomSign(1), 2)
			SetObject3DPhysicsAngularVelocity(branches[i].branchId, Random(-180, 180), Random(-180, 180), Random(-180, 180), 20)
		next i
		c.cactiState = 1
	endif
endfunction (c.cactiState)

/*function killCacti(cacti as Cacti)
	i as float
	j as integer = 0
	debrisPieces as integer[5]
	for i = -0.2 to 0.2 step 0.1
		debris = CreateObjectBox(0.2, 2.5, 0.2)
		SetObjectColor(debris, 0, 255, 0, 255)
		SetObjectPosition(debris, GetObjectX(cacti.cactiBranches[0].branchId)+i, GetObjectY(cacti.cactiBranches[0].branchId)+i, GetObjectZ(cacti.cactiBranches[0].branchId)+i)
		Create3DPhysicsDynamicBody(debris)
		SetObject3DPhysicsAngularVelocity(debris, Random(-180, 180), Random(-180, 180), Random(-180, 180), 10)
		SetObject3DPhysicsLinearVelocity(debris, i*2, 1, 0, 5)
		
		debrisPieces[j] = debris
		inc j
		
	next i
	//DeleteObject(cacti)
endfunction (debrisPieces)*/


main()

end
