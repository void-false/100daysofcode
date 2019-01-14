
// Project: normal 
// Created: 2019-01-13

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "normal" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts


SetSkyBoxVisible(1)
//SetSkyBoxHorizonSize(1,1)
// set a radius for the sphere which will also be used for the sphere cast
radius# = 5.0

// make a sphere, colour it, turns its collision off and position it
CreateObjectSphere(1,radius#*2,12,12)
SetObjectCollisionMode(1,0) // this is to stop it interfering with the collision with the map
SetObjectColor(1, 216, 48, 45, 255)
SetObjectPosition(1,0,radius#+40,-50)

for i = 2 to 4
        CreateObjectBox(i,25,15*i,25)
        SetObjectColor(i, 104, 103, 98, 255)
        SetObjectRotation(i,0,random(0,89),0)
        SetObjectPosition(i,(i-2)*50 ,2.5, -50)
next i

platform1 = CreateObjectBox(100, 1, 50)
SetObjectColor(platform1, 179, 179, 198, 255)
SetObjectRotation(platform1, 0,random(0,30),0)
SetObjectPosition(platform1, 0 ,0, -50)

platform2 = CreateObjectBox(100, 1, 50)
SetObjectColor(platform2, 239, 207, 79, 255)
SetObjectRotation(platform2, 0,random(0,30),0)
SetObjectPosition(platform2, GetObjectX(4)+110 ,0, -50)


CreateObjectPlane(5,2000,2000)
SetObjectColor(5, 45, 147, 216, 255)
SetObjectCollisionMode(5,0) 
SetObjectRotation(5,90,0,0)
SetObjectPosition(5,GetObjectX(3),0,GetObjectY(3))


SetCameraPosition(1,GetObjectX(1),50,-150)
SetCameraLookAt(1,0,0,0,0)

fallSpeed as float = 0.0
fallSpeed = resetFallSpeed()
factor as float = 0.2
isJumping as integer = 0
jumpHeight as float = 0.0
jumpHeight = resetJumpHeight()
do
	if GetRawKeyPressed(27) then exit
	
	SetCameraPosition(1,GetObjectX(1),50,-150)
	
	// save the old position of the sphere
	old_x# = GetObjectX(1)
	old_y# = GetObjectY(1)
	old_z# = GetObjectZ(1)

	// get player input
	joystick_x# = GetJoyStickX() * 1.5
	joystick_y# = GetJoyStickY() * -1.5

	// move the green sphere based on the player input
	MoveObjectLocalX(1,joystick_x#)
	MoveObjectLocalZ(1,joystick_y#)
	MoveObjectLocalY(1, -fallSpeed)
	fallSpeed = fallSpeed + factor
	if GetRawKeyPressed(asc(" " ))		
		isJumping = 1
	endif
	
	if isJumping
		MoveObjectLocalY(1, jumpHeight)
		jumpHeight = jumpHeight - factor
	endif

	// get the new position of the sphere
	new_x# = GetObjectX(1)
	new_y# = GetObjectY(1)
	new_z# = GetObjectZ(1)

	// sphere cast between the old and new positions of the sphere
	object_hit = ObjectSphereSlide(0,old_x#,old_y#,old_z#,new_x#,new_y#,new_z#,radius#)

	// the sphere has collide with a box then calculate sphere new position to give sliding collision
	if object_hit <> 0	
		SetObjectPosition(1, GetObjectRayCastSlideX(0), GetObjectRayCastSlideY(0), GetObjectRayCastSlideZ(0) )
		if GetObjectRayCastNormalY(0) > 0.9
			jumpHeight = resetJumpHeight()
			isJumping = 0
			fallSpeed = resetFallSpeed()
		endif
	endif
	sync()

loop

end

function resetJumpHeight()
	jumpHeight = 4.0
endfunction jumpHeight

function resetFallSpeed()
	fallSpeed = 0.1
endfunction fallSpeed
