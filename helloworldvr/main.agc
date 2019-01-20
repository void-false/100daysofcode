SetErrorMode(2)
#import_plugin AGKVR
SetWindowTitle( "helloworldvr" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window
//SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetSyncRate( 0, 0 ) // 30fps instead of 60 to save battery

UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

AGKVR.SetCameraRange(0.01, 1000.0)
InitError as integer
RightEyeImage as integer = 501
LeftEyeImage as integer = 502
InitError = AGKVR.Init(RightEyeImage, LeftEyeImage)
AGKVR.LockPlayerTurn(1)
AGKVR.LockPlayerPitch(0)
AGKVR.SetPlayerPosition(0, 0, -20)

//Right Hand
RightHandModel = LoadObjectWithChildren("RHand.FBX")
SetObjectScale(RightHandModel,1.15,1.15,1.15)
SetObjectPosition(RightHandModel,0.0,0.0,-0.07)
SetObjectRotation(RightHandModel,0.0,180.0,90.0)
FixObjectPivot(RightHandModel)
SetObjectAnimationSpeed(RightHandModel,20)
HandModelImg = LoadImage("Hand.png")
SetObjectImage(RightHandModel,HandModelImg,0)
SetObjectVisible(RightHandModel,0)
SetObjectCollisionMode(RightHandModel,0)

//Left Hand
LeftHandModel = LoadObjectWithChildren("LHand.FBX")
SetObjectScale(LeftHandModel,1.15,1.15,1.15)
SetObjectPosition(LeftHandModel,0.0,0.0,-0.07)
SetObjectRotation(LeftHandModel,0.0,180.0,270.0)
FixObjectPivot(LeftHandModel)
SetObjectAnimationSpeed(LeftHandModel,20)
SetObjectImage(LeftHandModel,HandModelImg,0)
SetObjectVisible(LeftHandModel,0)
SetObjectCollisionMode(LeftHandModel,0)

SetSkyBoxVisible(1)

Create3DPhysicsWorld(1)

SetCameraPosition(1, 0,  15, -30)
SetCameraLookAt(1, 0, 0, 50, 0)

ground = CreateObjectBox(1000, 1, 1000)
SetObjectColor(ground, 0, 200, 0, 255)
SetObjectPosition(ground, 0, -0.5, 0)
Create3DPhysicsStaticBody(ground)
SetObjectShapeBox(ground)

h1 = CreateObjectBox(1,5,1)
SetObjectPosition(h1, -9.5, 12.5, 0)
Create3DPhysicsDynamicBody(h1)
SetObjectShapeBox(h1)

h2 = CreateObjectBox(1,5,1)
SetObjectPosition(h2, -6.5, 12.5, 0)
Create3DPhysicsDynamicBody(h2)
SetObjectShapeBox(h2)

h3 = CreateObjectBox(2,1,1)
SetObjectPosition(h3, -8, 12.5, 0)
Create3DPhysicsDynamicBody(h3)
SetObjectShapeBox(h3)

e1 = CreateObjectBox(1,5,1)
SetObjectPosition(e1, -5, 12.5, 0)
Create3DPhysicsDynamicBody(e1)
SetObjectShapeBox(e1)

e2 = CreateObjectBox(2,1,1)
SetObjectPosition(e2, -3.5, 14.5, 0)
Create3DPhysicsDynamicBody(e2)
SetObjectShapeBox(e2)

e3 = CreateObjectBox(2,1,1)
SetObjectPosition(e3, -3.5, 12.5, 0)
Create3DPhysicsDynamicBody(e3)
SetObjectShapeBox(e3)

e4 = CreateObjectBox(2,1,1)
SetObjectPosition(e4, -3.5, 10.5, 0)
Create3DPhysicsDynamicBody(e4)
SetObjectShapeBox(e4)

l1 = CreateObjectBox(1,5,1)
SetObjectPosition(l1, -1.5, 12.5, 0)
Create3DPhysicsDynamicBody(l1)
SetObjectShapeBox(l1)

l2 = CreateObjectBox(2,1,1)
SetObjectPosition(l2, 0, 10.5, 0)
Create3DPhysicsDynamicBody(l2)
SetObjectShapeBox(l2)

l3 = CreateObjectBox(1,5,1)
SetObjectPosition(l3, 2, 12.5, 0)
Create3DPhysicsDynamicBody(l3)
SetObjectShapeBox(l3)

l4 = CreateObjectBox(2,1,1)
SetObjectPosition(l4, 3.5, 10.5, 0)
Create3DPhysicsDynamicBody(l4)
SetObjectShapeBox(l4)

o1 = CreateObjectBox(1,3,1)
SetObjectPosition(o1, 5.5, 12.5, 0)
Create3DPhysicsDynamicBody(o1)
SetObjectShapeBox(o1)

o2 = CreateObjectBox(4,1,1)
SetObjectPosition(o2, 7, 10.5, 0)
Create3DPhysicsDynamicBody(o2)
SetObjectShapeBox(o2)

o3 = CreateObjectBox(1,3,1)
SetObjectPosition(o3, 8.5, 12.5, 0)
Create3DPhysicsDynamicBody(o3)
SetObjectShapeBox(o3)

o4 = CreateObjectBox(4,1,1)
SetObjectPosition(o4, 7, 14.5, 0)
Create3DPhysicsDynamicBody(o4)
SetObjectShapeBox(o4)

v1 = CreateObjectBox(1,6,1)
SetObjectPosition(v1, -6, 2.5, 0)
RotateObjectLocalZ(v1, 20)
Create3DPhysicsDynamicBody(v1)
SetObjectShapeBox(v1)

v2 = CreateObjectBox(1,6,1)
SetObjectPosition(v2, -3, 2.5, 0)
RotateObjectLocalZ(v2, -20)
Create3DPhysicsDynamicBody(v2)
SetObjectShapeBox(v2)


vi1 = CreateObjectBox(1,3,1)
SetObjectPosition(vi1, -8.0, 5, 0)
Create3DPhysicsDynamicBody(vi1)
SetObjectShapeBox(vi1)



vi2 = CreateObjectBox(1,3,1)
SetObjectPosition(vi2, -1, 5, 0)
Create3DPhysicsDynamicBody(vi2)
SetObjectShapeBox(vi2)

r1 = CreateObjectBox(1, 6, 1)
SetObjectPosition(r1, 1, 3, 0)
Create3DPhysicsDynamicBody(r1)
SetObjectShapeBox(r1)

r2 = CreateObjectBox(2, 1, 1)
SetObjectPosition(r2, 2.5, 5.5, 0)
Create3DPhysicsDynamicBody(r2)
SetObjectShapeBox(r2)

r3 = CreateObjectBox(1, 2, 1)
SetObjectPosition(r3, 4, 5, 0)
Create3DPhysicsDynamicBody(r3)
SetObjectShapeBox(r3)

r4 = CreateObjectBox(3, 1, 1)
SetObjectPosition(r4, 3, 3.5, 0)
Create3DPhysicsDynamicBody(r4)
SetObjectShapeBox(r4)

r5 = CreateObjectBox(3, 1, 1)
SetObjectPosition(r5, 2.5, 1.5, 0)
RotateObjectLocalZ(r5, -65)
Create3DPhysicsDynamicBody(r5)
SetObjectShapeBox(r5)
SetObject3DPhysicsMass(r5, 0.01)




ri1 = CreateObjectBox(1, 1, 1)
SetObjectPosition(ri1, 4.7, 0.5, 0)
Create3DPhysicsDynamicBody(ri1)
SetObjectShapeBox(ri1)





shelf = CreateObjectBox(23, 1, 2)
SetObjectColor(shelf, 100, 10, 60, 255)
SetObjectPosition(shelf, 0, 9.5, 0)
Create3DPhysicsDynamicBody(shelf)
SetObjectShapeBox(shelf)

leg1 = CreateObjectBox(1, 9, 2)
SetObjectColor(leg1, 100, 10, 60, 255)
SetObjectPosition(leg1, -11, 4.5, 0)
Create3DPhysicsDynamicBody(leg1)
SetObjectShapeBox(leg1)

leg2 = CreateObjectBox(1, 9, 2)
SetObjectColor(leg2, 100, 10, 60, 255)
SetObjectPosition(leg2, 11, 4.5, 0)
Create3DPhysicsDynamicBody(leg2)
SetObjectShapeBox(leg2)

v = CreateVector3()

joints as integer[20]

joints[0] = Create3DPhysicsFixedJoint(h1, h3, v)
joints[1] = Create3DPhysicsFixedJoint(h2, h3, v)
joints[2] = Create3DPhysicsFixedJoint(e1, e2, v)
joints[3] = Create3DPhysicsFixedJoint(e1, e3, v)
joints[4] = Create3DPhysicsFixedJoint(e1, e4, v)
joints[5] = Create3DPhysicsFixedJoint(l1, l2, v)
joints[6] = Create3DPhysicsFixedJoint(l3, l4, v)
joints[7] = Create3DPhysicsFixedJoint(o1, o2, v)
joints[8] = Create3DPhysicsFixedJoint(o2, o3, v)
joints[9] = Create3DPhysicsFixedJoint(o3, o4, v)
joints[10] = Create3DPhysicsFixedJoint(vi1, leg1, v)
joints[11] = Create3DPhysicsFixedJoint(vi1, shelf, v)
joints[12] = Create3DPhysicsFixedJoint(vi2, shelf, v)
joints[13] = Create3DPhysicsFixedJoint(r1, r2, v)
joints[14] = Create3DPhysicsFixedJoint(r2, r3, v)
joints[15] = Create3DPhysicsFixedJoint(r3, r4, v)
joints[16] = Create3DPhysicsFixedJoint(r4, r5, v)
joints[17] = Create3DPhysicsFixedJoint(r1, shelf, v)
joints[18] = Create3DPhysicsFixedJoint(r2, shelf, v)
joints[19] = Create3DPhysicsFixedJoint(r3, shelf, v)

for i = 0 to 19
	Set3DPhysicsJointBreakingThreshold(joints[i], 1)
next i





box = CreateObjectBox(5, 5, 1)
SetObjectColor(box, 100, 50, 75, 255)
SetObjectPosition(box, 11, 0.5, -8)
Create3DPhysicsKinematicBody(box)
//SetObjectShapeBox(box)
//SetObject3DPhysicsCanSleep(box, 0) 
SetObject3DPhysicsMass(box, 100)


SetObjectVisible(vi1, 0)
SetObjectVisible(vi2, 0)

playerPosX as float
playerPosY as float
playerPosZ as float
newPlayerPosX as float
newPlayerPosY as float
newPlayerPosZ as float
Rvalue as float
Lvalue as float

s1 = CreateObjectSphere(0.15, 5, 5)
SetObjectColor(s1, 200, 0, 0, 255)
Create3DPhysicsKinematicBody(s1)
SetObjectVisible(s1, 0)
s2 = CreateObjectSphere(0.15, 5, 5)
SetObjectColor(s2, 0, 0, 200, 255)
Create3DPhysicsKinematicBody(s2)
SetObjectVisible(s2, 0)

do
    if GetRawKeyPressed(27) then exit
    
    playerPosX = AGKVR.GetPlayerX()
	playerPosY = AGKVR.GetPlayerY()
	playerPosZ = AGKVR.GetPlayerZ()
    
	if GetRawKeyPressed(asc(" "))
		SetObject3DPhysicsLinearVelocity(box, 0, 0, 1, 10)
	endif
	if GetRawKeyState(asc("Q")) then MoveCameraLocalY(1, 1)
	if GetRawKeyState(asc("Z")) then MoveCameraLocalY(1, -1)
	/*if GetRawKeyState(asc("W")) then MoveCameraLocalZ(1, 1)
	if GetRawKeyState(asc("S")) then MoveCameraLocalZ(1, -1)
	if GetRawKeyState(asc("A")) then MoveCameraLocalX(1, -1)
	if GetRawKeyState(asc("D")) then MoveCameraLocalX(1, 1)*/
	if GetRawKeyState(asc("W")) then AGKVR.MovePlayerLocalZ(0.1)
	if GetRawKeyState(asc("S")) then AGKVR.MovePlayerLocalZ(-0.1)
	if GetRawKeyState(asc("A")) then AGKVR.MovePlayerLocalX(-0.1)
	if GetRawKeyState(asc("D")) then AGKVR.MovePlayerLocalX(0.1)
	if GetPointerPressed() 
		startx# = GetPointerX()
		starty# = GetPointerY()
		angx# = GetCameraAngleX(1)
		angy# = GetCameraAngleY(1)
	endif
	
	AGKVR.MovePlayerLocalX(AGKVR.LeftController_JoyX() * 0.06)
	AGKVR.MovePlayerLocalZ(AGKVR.LeftController_JoyY() * 0.06)
	
	Rvalue = AGKVR.RightController_Trigger( )
	Lvalue = AGKVR.LeftController_Trigger( )
	SetObjectAnimationFrame(RightHandModel, GetObjectAnimationName( RightHandModel, 1 ), GetObjectAnimationDuration(RightHandModel,GetObjectAnimationName( RightHandModel, 1 ))*Rvalue,0)
	SetObjectAnimationFrame(LeftHandModel, GetObjectAnimationName( LeftHandModel, 1 ), GetObjectAnimationDuration(LeftHandModel,GetObjectAnimationName( LeftHandModel, 1 ))*Lvalue,0)
	
	//Position Hand Objects
	if  AGKVR.RightControllerFound( ) = 1
		SetObjectPosition( RightHandModel, AGKVR.GetRightHandX(), AGKVR.GetRightHandY(), AGKVR.GetRightHandZ())
		SetObjectRotation( RightHandModel, AGKVR.GetRightHandAngleX(), AGKVR.GetRightHandAngleY(), AGKVR.GetRightHandAngleZ())
		SetObjectVisible( RightHandModel, 1 )
		SetObjectPosition(s1, AGKVR.GetRightHandX(), AGKVR.GetRightHandY(), AGKVR.GetRightHandZ())
	else
		SetObjectVisible( RightHandModel, 0 )
	endif
	
	if  AGKVR.LeftControllerFound( ) = 1
		SetObjectPosition( LeftHandModel, AGKVR.GetLeftHandX(), AGKVR.GetLeftHandY(), AGKVR.GetLeftHandZ())
		SetObjectRotation( LeftHandModel, AGKVR.GetLeftHandAngleX(), AGKVR.GetLeftHandAngleY(), AGKVR.GetLeftHandAngleZ())
		SetObjectVisible( LeftHandModel, 1 )
		SetObjectPosition(s2, AGKVR.GetLeftHandX(), AGKVR.GetLeftHandY(), AGKVR.GetLeftHandZ())
	else
		SetObjectVisible( LeftHandModel, 0 )
	endif

	if GetPointerState()
		fDiffX# = (GetPointerX() - startx#)/5.0
		fDiffY# = (GetPointerY() - starty#)/5.0
		if ( newX# > 89 ) then newX# = 89
		if ( newX# < -89 ) then newX# = -89
		SetCameraRotation( 1, angx# + fDiffY#, angy# + fDiffX#, 0 )
	endif
	MoveObjectLocalX(box, GetDirectionX()/2)
	MoveObjectLocalZ(box, -GetDirectionY()/2)
	newPlayerPosX = AGKVR.GetPlayerX()
	newPlayerPosY = AGKVR.GetPlayerY()
	newPlayerPosZ = AGKVR.GetPlayerZ()
	if ObjectSphereSlide(0, playerPosX, playerPosY+0.1, playerPosZ, newPlayerPosX, newPlayerPosY+0.1, newPlayerPosZ, 0.1) > 0
		newPlayerPosX = GetObjectRayCastSlideX(0)
		newPlayerPosY = GetObjectRayCastSlideY(0)-0.1
		newPlayerPosZ = GetObjectRayCastSlideZ(0)
		AGKVR.SetPlayerPosition(newPlayerPosX, newPlayerPosY, newPlayerPosZ)
	endif
	
	

	SetCameraPosition(1, AGKVR.GetHMDX(), AGKVR.GetHMDY(), AGKVR.GetHMDZ())
	SetCameraRotation(1, AGKVR.GetHMDAngleX(), AGKVR.GetHMDAngleY(), AGKVR.GetHMDAngleZ())

	Step3DPhysicsWorld()
	AGKVR.UpdatePlayer()
	AGKVR.Render()
    Sync()
loop

end
