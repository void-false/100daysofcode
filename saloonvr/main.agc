SetErrorMode(2)

//#import_plugin AGKVR

SetWindowTitle("Saloon VR")
SetWindowSize(1024, 768, 0)
SetVirtualResolution(1024, 768)
SetWindowAllowResize(1)
//SetSyncRate(3, 0)

/*AGKVR.SetCameraRange(0.1, 1000)
initError as integer
initError = AGKVR.Init(500, 501)*/

SetSkyBoxVisible(1)

gosub makeObjects

//AGKVR.SetPlayerPosition(2, 0, 0)

isFired as integer = 0
isBulletMoving as integer = 0

SetCameraPosition(1, 1, 1, 1)
SetCameraRange(1, 0.01, 1000)
SetCameraLookAt(1, 0, 1.2, 0, 0)
do
	if GetRawKeyPressed(27) then exit
	
	if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, 0.01)
	if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -0.01)
	if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -0.01)
	if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, 0.01)
	
	if GetRawKeyState(16) and GetRawKeyState(asc("W")) then RotateObjectLocalX(gun, -1)
	if GetRawKeyState(16) and GetRawKeyState(asc("S")) then RotateObjectLocalX(gun, 1)
	if GetRawKeyState(16) and GetRawKeyState(asc("A")) then RotateObjectLocalY(gun, -1)
	if GetRawKeyState(16) and GetRawKeyState(asc("D")) then RotateObjectLocalY(gun, 1)
	
	if GetRawKeyState(asc(" ")) 
		MoveObjectLocalX(bullet, sin(GetObjectAngleY(gun))/1000.0)
		MoveObjectLocalZ(bullet, cos(GetObjectAngleY(gun))/1000.0) // COOL
	endif
	
	
	if GetPointerPressed()
        startx# = GetPointerX()
        starty# = GetPointerY()
        angx# = GetCameraAngleX(1)
        angy# = GetCameraAngleY(1)
    endif
    if GetPointerState()
        fDiffX# = (GetPointerX() - startx#)/2.0
        fDiffY# = (GetPointerY() - starty#)/2.0
        if ( newX# > 89 ) then newX# = 89
        if ( newX# < -89 ) then newX# = -89
        SetCameraRotation( 1, angx# + fDiffY#, angy# + fDiffX#, 0 )
    endif
	
	/*if GetRawKeyState(asc("W")) then AGKVR.MovePlayerLocalZ(0.06)
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
	endif

	
	
	AGKVR.UpdatePlayer()
	AGKVR.Render()*/
	//SetCameraLookAt(1, getobjectx(bullet), GetObjectY(bullet), GetObjectZ(bullet), 0)
	SYNC()
loop

end

makeObjects:
	ground = CreateObjectBox(100, 0, 100)
	SetObjectColor(ground, 244, 194, 44, 255)
	
	gun = CreateObjectBox(0.02, 0.15, 0.2)
	SetObjectColor(gun, 224, 221, 210, 255)
	SetObjectPosition(gun, 0, 1.2, 0)
	
	bullet = CreateObjectBox(0.022, 0.022, 0.022)
	SetObjectColor(bullet, 219, 112, 50, 255)
	SetObjectPosition(bullet, 0, 1.2, 0)

return

end
