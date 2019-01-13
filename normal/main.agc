
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











// set a radius for the sphere which will also be used for the sphere cast
radius# = 5.0

// make a sphere, colour it, turns its collision off and position it
CreateObjectSphere(1,radius#*2,12,12)
SetObjectCollisionMode(1,0) // this is to stop it interfering with the collision with the map
SetObjectColor(1,0,255,0,255)
SetObjectPosition(1,-50,radius#,-50)

// make three blocks to act as a map
for i = 2 to 4
        CreateObjectBox(i,25,15,25)
        SetObjectColor(i,255,0,0,255)
        SetObjectRotation(i,0,random(0,89),0)
        SetObjectPosition(i,(i-2)*50 ,2.5, -50)
next i

// create a plane, turn its collision off, rotate it and position it under the middle box to act as a ground
// this is purely cosmetic
CreateObjectPlane(5,200,200)
//SetObjectCollisionMode(5,0) // this is to stop it interfering with the collision with the map
SetObjectRotation(5,90,0,0)
SetObjectPosition(5,GetObjectX(3),0,GetObjectY(3))



// position and orientate camera
SetCameraPosition(1,0,20,-150)
SetCameraLookAt(1,0,0,0,0)

// main loop
do
	if GetRawKeyPressed(27) then exit
	
	// save the old position of the sphere
	old_x# = GetObjectX(1)
	old_y# = GetObjectY(1)
	old_z# = GetObjectZ(1)

	// get player input
	joystick_x# = GetJoyStickX()
	joystick_y# = GetJoyStickY() * -1

	// move the green sphere based on the player input
	MoveObjectLocalX(1,joystick_x#)
	MoveObjectLocalZ(1,joystick_y#)
	if GetRawKeyPressed(asc("Q")) then MoveObjectLocalY(1, 1)
	if GetRawKeyPressed(asc("Z")) then MoveObjectLocalY(1, -1)
	

	// get the new position of the sphere
	new_x# = GetObjectX(1)
	new_y# = GetObjectY(1)
	new_z# = GetObjectZ(1)

	// sphere cast between the old and new positions of the sphere
	object_hit = ObjectSphereSlide(0,old_x#,old_y#,old_z#,new_x#,new_y#,new_z#,radius#)

	// the sphere has collide with a box then calculate sphere new position to give sliding collision
	// we do not need to know the Y component of the collision as the sphere only moves on the xz plane
	if object_hit <> 0
			SetObjectPosition(1, GetObjectRayCastSlideX(0), GetObjectRayCastSlideY(0), GetObjectRayCastSlideZ(0) )
	endif
	
	Print(GetObjectRayCastNormalX(0))
	Print(GetObjectRayCastNormalY(0))
	Print(GetObjectRayCastNormalZ(0))



	sync()

loop

end
