SetErrorMode(2)

#import_plugin AGKVR

SetWindowTitle("Saloon VR")
SetWindowSize(1024, 768, 0)
SetWindowAllowResize(1)
SetSyncRate(0, 0)

AGKVR.SetCameraRange(0.1, 1000)
initError as integer
initError = AGKVR.Init(500, 501)

SetSkyBoxVisible(1)

gosub makeObjects

AGKVR.SetPlayerPosition(2, 0, 0)

isFired as integer = 0
isBulletMoving as integer = 0

do
	if GetRawKeyPressed(27) then exit
	
	if GetRawKeyState(asc("W")) then AGKVR.MovePlayerLocalZ(0.06)
	if GetRawKeyState(asc("S")) then AGKVR.MovePlayerLocalZ(-0.06)
	
	SetCameraPosition(1, AGKVR.GetHMDX(), AGKVR.GetHMDY(), AGKVR.GetHMDZ())
	SetCameraRotation(1, AGKVR.GetHMDAngleX(), AGKVR.GetHMDAngleY(), AGKVR.GetHMDAngleZ())
	
	if AGKVR.RightControllerFound()
		SetObjectPosition(gun, AGKVR.GetRightHandX(), AGKVR.GetRightHandY(), AGKVR.GetRightHandZ())
		SetObjectRotation(gun, AGKVR.GetRightHandAngleX(), AGKVR.GetRightHandAngleY(), AGKVR.GetRightHandAngleZ())
		if not isFired and not isBulletMoving
			SetObjectPosition(bullet, GetObjectX(gun), GetObjectY(gun)+0.1, GetObjectZ(gun))
		endif
	endif
	
	if isBulletMoving
		MoveObjectLocalX(bullet, cos(AGKVR.GetRightHandX())/100.0)
		MoveObjectLocalZ(bullet, sin(AGKVR.GetRightHandZ())/100.0)
	endif
	
	if isFired = 1 and AGKVR.RightController_Trigger() = 0
		isFired = 0
	endif
	
	if isFired = 0 and AGKVR.RightController_Trigger() = 1
		AGKVR.RightController_TriggerPulse(0, 1000)
		isFired = 1
		isBulletMoving = 1
		RotateObjectLocalX(gun, -15)
	endif

	
	
	AGKVR.UpdatePlayer()
	AGKVR.Render()
	sync()
loop

end

makeObjects:
	ground = CreateObjectBox(100, 0, 100)
	SetObjectColor(ground, 244, 194, 44, 255)
	
	gun = CreateObjectBox(0.02, 0.15, 0.2)
	SetObjectColor(gun, 224, 221, 210, 255)
	SetObjectPosition(gun, 0, 1.2, 0)
	
	bullet = CreateObjectBox(0.02, 0.02, 0.02)
	SetObjectColor(bullet, 219, 112, 50, 255)

return

end
