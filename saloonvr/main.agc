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

do
	if GetRawKeyPressed(27) then exit
	
	if GetRawKeyState(asc("W")) then AGKVR.MovePlayerLocalZ(0.06)
	if GetRawKeyState(asc("S")) then AGKVR.MovePlayerLocalZ(-0.06)
	
	SetCameraPosition(1, AGKVR.GetHMDX(), AGKVR.GetHMDY(), AGKVR.GetHMDZ())
	SetCameraRotation(1, AGKVR.GetHMDAngleX(), AGKVR.GetHMDAngleY(), AGKVR.GetHMDAngleZ())
	
	AGKVR.UpdatePlayer()
	AGKVR.Render()
	sync()
loop

end

makeObjects:
	ground = CreateObjectBox(100, 0, 100)
	SetObjectColor(ground, 244, 194, 44, 255)
	
	gun = CreateObjectBox(0.2, 0.2, 0.2)
	SetObjectColor(gun, 224, 221, 210, 255)
	SetObjectPosition(gun, 0, 1.2, 0)

return

end
