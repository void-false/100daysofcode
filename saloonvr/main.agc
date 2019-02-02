SetErrorMode(0)

#import_plugin AGKVR

#include "createCacti.agc"

SetWindowTitle("Saloon VR")
SetWindowSize(1024, 768, 0)
SetVirtualResolution(1024, 768)
SetWindowAllowResize(1)
SetAntialiasMode(1)

Create3DPhysicsWorld(1)

if AGKVR.IsHmdPresent()
	AGKVR.SetCameraRange(0.01, 1000.0)
	initError as integer
	initError = AGKVR.Init(500, 501)
	AGKVR.SetPlayerPosition(2, 0, 0)
	SetSyncRate(0, 0)
endif

SetSkyBoxVisible(1)
gosub makeObjects

// shadows 
SetShadowMappingMode( 3 )
SetShadowSmoothing( 0 ) // random sampling
SetShadowMapSize( 1024, 1024 )
SetShadowRange( -1 ) // use the full camera range
SetShadowBias( 0.0012 ) // offset shadows slightly to avoid shadow artifacts

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

dw as float
dh as float
dl as float

cactiParts as integer = 6

SetCameraPosition(1, -5, 1.86, 0.25)
SetCameraRange(1, 0.01, 1000)
SetCameraLookAt(1, -12, -5, 24, 0)

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
	
	if GetRawKeyPressed(asc(" "))
		gosub alternativeKillCacti
		debrisX = GetObjectX(cacti2a)
		debrisY = GetObjectY(cacti2a)
		debrisZ = GetObjectZ(cacti2a)
		gosub explodeCacti
		debrisX = GetObjectX(cacti2b)
		debrisY = GetObjectY(cacti2b)
		debrisZ = GetObjectZ(cacti2b)
		gosub explodeCacti
		DeleteObject(cacti2a)
		DeleteObject(cacti2b)
		DeleteObject(cacti2c)
		DeleteObject(cacti2d)
		DeleteObject(cacti2e)
		DeleteObject(cacti2f)
	endif
	
	if GetRawKeyPressed(asc("O"))
		gosub alternativeKillCacti1
		debrisX = GetObjectX(cacti2b)
		debrisY = GetObjectY(cacti2b)
		debrisZ = GetObjectZ(cacti2b)
		gosub explodeCacti
		DeleteObject(cacti2b)
		DeleteObject(cacti2e)
		DeleteObject(cacti2f)
	endif
	
		if GetRawKeyPressed(asc("P"))
		gosub alternativeKillCacti2
		debrisX = GetObjectX(cacti2a)
		debrisY = GetObjectY(cacti2a)
		debrisZ = GetObjectZ(cacti2a)
		gosub explodeCacti
		DeleteObject(cacti2a)
		DeleteObject(cacti2c)
		DeleteObject(cacti2d)
	endif

	

	//SetObjectRotation(bullet, GetObjectAngleX(gun), GetObjectAngleY(gun), GetObjectAngleZ(gun))
	//RotateObjectLocalY(bullet, -90)
	
	if GetRawKeyState(asc(" ")) 
		MoveObjectLocalX(bullet, 0.01)
	elseif GetRawKeyReleased(asc(" "))
		SetObjectPosition(bullet, GetObjectX(gun), GetObjectY(gun), GetObjectZ(gun))
	endif
	
	if GetRawKeyPressed(asc("R")) then SetObjectRotation(gun, 0, 0, 0)
	
	if GetPointerPressed()
        startx# = GetPointerX()
        starty# = GetPointerY()
        angx# = GetCameraAngleX(1)
        angy# = GetCameraAngleY(1)
    endif
    if GetPointerState()
        fDiffX# = (GetPointerX() - startx#)/2.0
        fDiffY# = (GetPointerY() - starty#)/2.0
        SetCameraRotation( 1, angx# + fDiffY#, angy# + fDiffX#, 0 )
    endif
	
	if AGKVR.IsHMDPresent()
		
		if GetRawKeyState(asc("W")) then AGKVR.MovePlayerLocalZ(0.06)
		if GetRawKeyState(asc("S")) then AGKVR.MovePlayerLocalZ(-0.06)
		
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
				SetObjectRotation(hammer, (AGKVR.RightController_JoyY()+1)*45, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))
			endif
			
			if dragHammerStart and AGKVR.RightController_JoyY() = 0
				dragHammerStart = 0
				SetObjectRotation(hammer, 90, GetObjectAngleY(hammer), GetObjectAngleZ(hammer))		
			endif
			
			if dragHammerStart and AGKVR.RightController_JoyY() < -0.8
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
				MoveObjectLocalZ(bullet, 0.1)
					
			else
				SetObjectPosition(bullet, GetObjectX(gun), GetObjectY(gun), GetObjectZ(gun))
				SetObjectRotation(bullet, GetObjectAngleX(gun), GetObjectAngleY(gun), GetObjectAngleZ(gun))
			endif
			
			bulletEndX = GetObjectX(bullet)
			bulletEndY = GetObjectY(bullet)
			bulletEndZ = GetObjectZ(bullet)
			
			objHit = ObjectSphereSlide(0, bulletStartX, bulletStartY, bulletStartZ, bulletEndX, bulletEndY, bulletEndZ, 0.011)
			if objHit >= cacti1a and objHit <= cacti1f
				if objHit = cacti1a or objHit = cacti1c or objHit = cacti1d
					debrisX = GetObjectX(cacti1a)
					debrisY = GetObjectY(cacti1a)
					debrisZ = GetObjectZ(cacti1a)
					DeleteObject(cacti1a)
					DeleteObject(cacti1c)
					DeleteObject(cacti1d)
					gosub explodeCacti
					if cactiParts > 3 
						debrisX = GetObjectX(cacti1b)
						debrisY = GetObjectY(cacti1b)
						debrisZ = GetObjectZ(cacti1b)
						DeleteObject(cacti1b)
						DeleteObject(cacti1e)
						DeleteObject(cacti1f)
						gosub explodeCacti
					endif
				endif
				if objHit = cacti1b or objHit = cacti1e or objHit = cacti1f 
					debrisX = GetObjectX(cacti1b)
					debrisY = GetObjectY(cacti1b)
					debrisZ = GetObjectZ(cacti1b)
					cactiParts = cactiParts - 3
					DeleteObject(cacti1b)
					DeleteObject(cacti1e)
					DeleteObject(cacti1f)
					gosub explodeCacti
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

end

alternativeKillCacti:
	SetObjectShapeCapsule(cacti1a, 1)
	SetObjectShapeCapsule(cacti1b, 1)
	SetObjectShapeCapsule(cacti1c, 0)
	SetObjectShapeCapsule(cacti1d, 1)
	SetObjectShapeCapsule(cacti1e, 0)
	SetObjectShapeCapsule(cacti1f, 1)
	Create3DPhysicsDynamicBody(cacti1a)
	Create3DPhysicsDynamicBody(cacti1b)
	Create3DPhysicsDynamicBody(cacti1c)
	Create3DPhysicsDynamicBody(cacti1d)
	Create3DPhysicsDynamicBody(cacti1e)
	Create3DPhysicsDynamicBody(cacti1f)
	SetObject3DPhysicsLinearVelocity(cacti1a, 0, 0, 1, 5)
	SetObject3DPhysicsLinearVelocity(cacti1b, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1c, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1d, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1e, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1f, -1, 0, 1, 2)
	SetObject3DPhysicsAngularVelocity(cacti1a, 0, 0, 10, 15)
	SetObject3DPhysicsAngularVelocity(cacti1b, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1c, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1d, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1e, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1f, Random(1,10), 1, Random(1,10), 5)
return

alternativeKillCacti1:
	SetObjectShapeCapsule(cacti1b, 1)
	SetObjectShapeCapsule(cacti1e, 0)
	SetObjectShapeCapsule(cacti1f, 1)
	Create3DPhysicsDynamicBody(cacti1b)
	Create3DPhysicsDynamicBody(cacti1e)
	Create3DPhysicsDynamicBody(cacti1f)
	SetObject3DPhysicsLinearVelocity(cacti1b, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1e, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1f, -1, 0, 1, 2)
	SetObject3DPhysicsAngularVelocity(cacti1b, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1e, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1f, Random(1,10), 1, Random(1,10), 5)
return

alternativeKillCacti2:
	SetObjectShapeCapsule(cacti1a, 1)
	SetObjectShapeCapsule(cacti1c, 0)
	SetObjectShapeCapsule(cacti1d, 1)
	Create3DPhysicsDynamicBody(cacti1a)
	Create3DPhysicsDynamicBody(cacti1c)
	Create3DPhysicsDynamicBody(cacti1d)
	SetObject3DPhysicsLinearVelocity(cacti1a, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1c, -1, 0, 1, 2)
	SetObject3DPhysicsLinearVelocity(cacti1d, -1, 0, 1, 2)
	SetObject3DPhysicsAngularVelocity(cacti1a, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1c, Random(1,10), 1, Random(1,10), 5)
	SetObject3DPhysicsAngularVelocity(cacti1d, Random(1,10), 1, Random(1,10), 5)
return

explodeCacti:
	i as float
	for i = -0.2 to 0.2 step 0.1		
		dw = Random(10, 20) / 100.0
		dh = Random(30, 60) / 100.0
		dl = Random(5, 10) / 100.0
		debris = CreateObjectBox(dw, dh, dl)
		SetObjectColor(debris, 58, 224, 49, 255)
		SetObjectPosition(debris, debrisX+i, debrisY+i, debrisZ+i)
		Create3DPhysicsDynamicBody(debris)
		SetObject3DPhysicsAngularVelocity(debris, Random(0,2)-1, Random(0,2)-1, Random(0,2)-1, Random(10,20))
		SetObject3DPhysicsLinearVelocity(debris, Random(0,2)-1, Random(2,3), Random(0,2)-1, Random(1,4))
		SetObjectCastShadow(debris, 1)
	next i	
return

makeObjects:
	ground = CreateObjectBox(100, 0, 100)
	SetObjectColor(ground, 244, 194, 44, 255)
	Create3DPhysicsKinematicBody(ground)
	SetObjectCastShadow(ground, 1)
	SetObjectReceiveShadow(ground, 1)
	SetObjectLightMode(ground, 1)
		
	gun = CreateObjectBox(0.02, 0.1, 0.05)
	SetObjectPosition(gun, 0, -0.03, -0.01)
	RotateObjectLocalX(gun, 15)
	FixObjectPivot(gun)
	SetObjectCollisionMode(gun, 0)

	handle = CreateObjectBox(0.025, 0.02, 0.05)
	SetObjectPosition(handle, 0, 0.015, 0)
	FixObjectToObject(handle, gun)
	SetObjectCollisionMode(handle, 0)
	
	body = CreateObjectBox(0.02, 0.05, 0.08)
	SetObjectPosition(body, 0, 0.03, 0.06)
	FixObjectToObject(body, gun)
	SetObjectCollisionMode(body, 0)

	drum = CreateObjectCylinder(0.06, 0.06, 6)
	RotateObjectLocalX(drum, 90)
	SetObjectPosition(drum, 0, 0.024, 0.06)
	FixObjectToObject(drum, gun)
	SetObjectCollisionMode(drum, 0)

	barrel = CreateObjectCylinder(0.2, 0.02, 10)
	RotateObjectLocalX(barrel, 90)
	SetObjectPosition(barrel, 0, 0.043, 0.19)
	FixObjectToObject(barrel, gun)
	SetObjectCollisionMode(barrel, 0)

	sight = CreateObjectCone(0.01, 0.01, 3)
	SetObjectPosition(sight, 0, 0.057, 0.28)
	FixObjectToObject(sight, gun)
	SetObjectCollisionMode(sight, 0)

	hammer = CreateObjectBox(0.01, 0.01, 0.04)
	SetObjectPosition(hammer, 0, 0.005, -0.02)
	FixObjectPivot(hammer)
	SetObjectPosition(hammer, 0, 0.025, 0.01)
	FixObjectToObject(hammer, gun)
	SetObjectCollisionMode(hammer, 0)

	hammerAxis = CreateObjectCylinder(0.018, 0.015, 10)
	SetObjectPosition(hammerAxis, 0, 0.03, 0.015)
	RotateObjectLocalZ(hammerAxis, 90)
	FixObjectToObject(hammerAxis, gun)
	SetObjectCollisionMode(hammerAxis, 0)

	trigger = CreateObjectBox(0.01, 0.01, 0.04)
	SetObjectPosition(trigger, 0, 0.005, 0.02)
	FixObjectPivot(trigger)
	RotateObjectLocalX(trigger, 45)
	SetObjectPosition(trigger, 0, -0.015, 0.015)
	FixObjectToObject(trigger, gun)
	SetObjectCollisionMode(trigger, 0)

	triggerAxis = CreateObjectCylinder(0.018, 0.01, 10)
	SetObjectPosition(triggerAxis, 0, -0.012, 0.023)
	RotateObjectLocalZ(triggerAxis, 90)
	FixObjectToObject(triggerAxis, gun)
	SetObjectCollisionMode(triggerAxis, 0)

	//RotateObjectLocalX(gun, 45)
	//FixObjectPivot(gun)
	
	
	/*gun = CreateObjectBox(0.02, 0.15, 0.2)
	SetObjectColor(gun, 224, 221, 210, 255)
	SetObjectPosition(gun, 0, 1.2, 0)*/
	
	bullet = CreateObjectBox(0.022, 0.022, 0.022)
	SetObjectColor(bullet, 119, 27, 12, 255)
	SetObjectPosition(bullet, 0, 1.2, 0)
	SetObjectCollisionMode(bullet, 0)
	

	
	saloonFloor = CreateObjectBox(10, 0.3, 1)
	SetObjectColor(saloonFloor,76,0,11, 255)
	SetObjectPosition(saloonFloor, 0, 0.15, 10)
	
	saloonLeftBottom = CreateObjectBox(4.0, 0.7, 1)
	SetObjectColor(saloonLeftBottom,136,0,21, 255)
	SetObjectPosition(saloonLeftBottom, GetObjectX(saloonFloor)-3, GetObjectY(saloonFloor)+0.45, GetObjectZ(saloonFloor)+0.01)
	
	saloonRightBottom = CreateObjectBox(4.0, 0.7, 1)
	SetObjectColor(saloonRightBottom,136,0,21, 255)
	SetObjectPosition(saloonRightBottom, GetObjectX(saloonFloor)+3, GetObjectY(saloonFloor)+0.45, GetObjectZ(saloonFloor)+0.01)
	
	saloonMiddle = CreateObjectBox(10, 0.3, 1)
	SetObjectColor(saloonMiddle,136,0,21, 255)
	SetObjectPosition(saloonMiddle,  GetObjectX(saloonFloor), GetObjectY(saloonFloor)+2.3, GetObjectZ(saloonFloor))
	
	saloonTop = CreateObjectBox(10, 0.3, 1)
	SetObjectColor(saloonTop,136,0,21, 255)
	SetObjectPosition(saloonTop,  GetObjectX(saloonFloor), GetObjectY(saloonFloor)+4, GetObjectZ(saloonFloor))
	
	saloonLeft = CreateObjectBox(1, 4, 1)
	SetObjectColor(saloonLeft,255,165,79, 255)
	SetObjectPosition(saloonLeft,  GetObjectX(saloonFloor)-4.5, GetObjectY(saloonFloor)+2, GetObjectZ(saloonFloor)+0.1)
	
	saloonRight = CreateObjectBox(1, 4, 1)
	SetObjectColor(saloonRight,255,165,79, 255)
	SetObjectPosition(saloonRight,  GetObjectX(saloonFloor)+4.5, GetObjectY(saloonFloor)+2, GetObjectZ(saloonFloor)+0.1)
	
	saloonColumnLeft = CreateObjectBox(1, 4, 1)
	SetObjectColor(saloonColumnLeft,255,165,79, 255)
	SetObjectPosition(saloonColumnLeft,  GetObjectX(saloonFloor)-1.51, GetObjectY(saloonFloor)+2, GetObjectZ(saloonFloor)+0.1)
	
	saloonColumnRight = CreateObjectBox(1, 4, 1)
	SetObjectColor(saloonColumnRight,255,165,79, 255)
	SetObjectPosition(saloonColumnRight,  GetObjectX(saloonFloor)+1.51, GetObjectY(saloonFloor)+2, GetObjectZ(saloonFloor)+0.1)

	gosub createCacti

return

end
