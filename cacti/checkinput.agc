
checkInput:
	if GetRawKeyState(asc("W")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, camSpeed)
	if GetRawKeyState(asc("S")) and not GetRawKeyState(16) then MoveCameraLocalZ(1, -camSpeed)
	if GetRawKeyState(asc("A")) and not GetRawKeyState(16) then MoveCameraLocalX(1, -camSpeed)
	if GetRawKeyState(asc("D")) and not GetRawKeyState(16) then MoveCameraLocalX(1, camSpeed)
	if GetRawKeyState(asc("Q")) and not GetRawKeyState(16) then MoveCameraLocalY(1, camSpeed)
	if GetRawKeyState(asc("Z")) and not GetRawKeyState(16) then MoveCameraLocalY(1, -camSpeed)
	if GetRawMouseRightPressed()
		startx# = GetPointerX()
		starty# = GetPointerY()
		angx# = GetCameraAngleX(1)
		angy# = GetCameraAngleY(1)
	endif
	if GetRawMouseRightState()
		fDiffX# = (GetPointerX() - startx#)/2.0
		fDiffY# = (GetPointerY() - starty#)/2.0
		SetCameraRotation( 1, angx# + fDiffY#, angy# + fDiffX#, 0 )
	endif
return
