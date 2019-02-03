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

function main()
	
	ground = CreateObjectBox(100, 0, 100)
	SetObjectColor(ground, 244, 191, 66, 255)
	SetObjectPosition(ground, 0, 0, 0)
	Create3DPhysicsKinematicBody(ground)
	
	cacti = CreateObjectBox(1,5,1)
	SetObjectColor(cacti, 0, 255, 0, 255)
	SetObjectPosition(cacti, 0, 2.5, 0)
	RotateObjectLocalY(cacti, 42)

	debris as integer[5]
	killed as integer = 0

	do
		if GetRawKeyPressed(27) then exit
		
		if GetRawKeyPressed(asc(" ")) and killed = 0
			debris = killCacti(cacti)
			killed = 1
		elseif GetRawKeyPressed(asc(" ")) and killed = 1
			for i = 0 to 4
				DeleteObject(debris[i])
			next i
			killed = 2
		endif
		
		 
		
		for i = 0 to 4
			Print(debris[i])
		next i
	
		Step3DPhysicsWorld()
		Sync()
	loop
	
endfunction

function killCacti(cacti as integer)
	i as float
	j as integer = 0
	debrisPieces as integer[5]
	for i = -0.2 to 0.2 step 0.1
		debris = CreateObjectBox(0.2, 2.5, 0.2)
		SetObjectColor(debris, 0, 255, 0, 255)
		SetObjectPosition(debris, GetObjectX(cacti)+i, GetObjectY(cacti)+i, GetObjectZ(cacti)+i)
		Create3DPhysicsDynamicBody(debris)
		SetObject3DPhysicsAngularVelocity(debris, Random(-180, 180), Random(-180, 180), Random(-180, 180), 10)
		SetObject3DPhysicsLinearVelocity(debris, i*2, 1, 0, 5)
		
		debrisPieces[j] = debris
		inc j
		
	next i
	DeleteObject(cacti)
endfunction (debrisPieces)

function moveCacti(cacti as integer, dir as float)
	MoveObjectLocalX(cacti, dir)
	MoveObjectLocalZ(cacti, dir)
endfunction


main()

end
