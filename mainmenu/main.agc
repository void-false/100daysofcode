// Show all errors
SetErrorMode(2) 

// Set some display properties
SetVirtualResolution( 1024, 768 )
SetScissor( 0,0,0,0 )
SetGenerateMipmaps( 1 )
SetCameraRange( 1, 0.1, 100 )
SetWindowAllowResize( 1 )
UseNewDefaultFonts( 1 )


function main()
	
	SetSkyBoxVisible(1)
	SetShadowMappingMode(3)
	SetShadowSmoothing(1)
	SetShadowMapSize(2048, 2048)
	SetShadowRange(30)
	SetShadowBias(0.0012)
	
	SetCameraPosition(1, 0, 0.45, 0)
	SetCameraLookAt(1, 0, 0.45, 1.5, 0)
	
	ground = CreateObjectBox(100, 1, 100)
	SetObjectColor(ground, 244, 191, 66, 255)
	SetObjectPosition(ground, 0, -0.5, 0)
	SetObjectReceiveShadow(ground, 1)
	SetObjectLightMode(ground, 1)
	
	mainMenu = CreateObjectPlane(1.6, 0.9)
	SetObjectColor(mainMenu, 244, 113, 66, 255)
	SetObjectPosition(mainMenu, 0, 0.45, 1.5)
	SetObjectLightMode(mainMenu, 1)
	SetObjectCastShadow(mainMenu, 1)
	SetObjectReceiveShadow(mainMenu, 1)
	
	buttonPlay = CreateObjectPlane(0.32, 0.09)
	SetObjectColor(buttonPlay, 244, 227, 73, 255)
	SetObjectPosition(buttonPlay, 0, 0.7, 1.45)
	SetObjectCastShadow(buttonPlay, 1)
	SetObjectImage(buttonPlay, LoadImage("play.png"), 0)
	
	buttonHelp = CreateObjectPlane(0.32, 0.09)
	SetObjectColor(buttonHelp, 244, 227, 73, 255)
	SetObjectPosition(buttonHelp, 0, GetObjectY(buttonPlay) - 0.25 , 1.45)
	SetObjectCastShadow(buttonHelp, 1)
	SetObjectImage(buttonHelp, LoadImage("help.png"), 0)
	
	buttonExit = CreateObjectPlane(0.32, 0.09)
	SetObjectColor(buttonExit, 244, 227, 73, 255)
	SetObjectPosition(buttonExit, 0, GetObjectY(buttonHelp) - 0.25, 1.45)
	SetObjectCastShadow(buttonExit, 1)
	SetObjectImage(buttonExit, LoadImage("exit.png"), 0)
	
	do
		if GetRawKeyPressed(27) then exit

		gosub checkInput
		checkMenuButtons(buttonPlay, buttonHelp, buttonExit)
		
		Sync()
	loop
endfunction


main()

end

function checkMenuButtons(buttonPlay as integer, buttonHelp as integer, buttonExit as integer)
	if GetRawKeyState(asc("1")) then SetObjectPosition(buttonPlay, GetObjectX(buttonPlay), GetObjectY(buttonPlay), 1.483)
	if GetRawKeyReleased(asc("1")) then SetObjectPosition(buttonPlay, GetObjectX(buttonPlay), GetObjectY(buttonPlay), 1.45)
	if GetRawKeyState(asc("2")) then SetObjectPosition(buttonHelp, GetObjectX(buttonHelp), GetObjectY(buttonHelp), 1.483)
	if GetRawKeyReleased(asc("2")) then SetObjectPosition(buttonHelp, GetObjectX(buttonHelp), GetObjectY(buttonHelp), 1.45)
	if GetRawKeyState(asc("3")) then SetObjectPosition(buttonExit, GetObjectX(buttonExit), GetObjectY(buttonExit), 1.483)
	if GetRawKeyReleased(asc("3")) then SetObjectPosition(buttonExit, GetObjectX(buttonExit), GetObjectY(buttonExit), 1.45)
	
endfunction

checkInput:
	camSpeed as float = 0.01
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
