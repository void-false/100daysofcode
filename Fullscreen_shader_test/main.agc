
// Project: Fullscreen_shader_test 
// Created: 2014-11-18

// set window properties
SetWindowTitle( "Fullscreen_shader_test" )
SetWindowSize( 1024, 768, 0 )
SetPrintSize(16)
SetClearColor(0,0,0)
ClearScreen()

// set display properties
SetVirtualResolution( 1024, 768 )

// load media
bg = LoadImage("bg.png")
white = LoadImage("white.png")

// create render images
renderImage = GetImage(0, 0, 1024, 768)
shaderImage = CopyImage(renderImage, 0, 0, 1024, 768)
quadImage = CopyImage(renderImage, 0, 0, 1024, 768)

// create sprites
bgSpr = CreateSprite(bg)
SetSpriteSize(bg, 1024, 768)
SetSpritePosition(bgSpr, 0, 0)
SetSpriteVisible(bgSpr, 0)

whiteSpr = CreateSprite(white)
SetSpritePosition(whiteSpr, 0, 0)
SetSpriteVisible(whiteSpr, 0)

// create quad
quad = CreateObjectQuad()
SetObjectImage(quad, renderImage, 0)
SetObjectImage(quad,shaderImage, 1)


//==============================
box = CreateObjectBox(1, 1, 1)
SetObjectColor(box, 200, 0, 0, 255)

//==============================


// load shader
shader1 = LoadFullScreenShader("additive.ps")
shader2 = LoadFullScreenShader("subtractive.ps")
shader3 = LoadFullScreenShader("multiply.ps")
shader4 = LoadFullScreenShader("sepia.ps")
shader = 4
select shader
	case 1 : shaderName$ = "Additive blend" : SetObjectShader(quad, shader1) : endcase
	case 2 : shaderName$ = "Subtractive blend" : SetObjectShader(quad, shader2) : endcase
	case 3 : shaderName$ = "Multiplicative blend" : SetObjectShader(quad, shader3) : endcase
	case 4 : shaderName$ = "Sepia" : SetObjectShader(quad, shader4) : endcase
endselect

SetSyncRate(10000, 0)

do
	if GetRawKeyPressed(27) then exit
	// update the scene
    Update(GetFrameTime())
    
	// render the 2D scene
    SetRenderToImage( renderImage, -1 )
	ClearScreen()
	SetSpriteVisible(bgSpr, 1)
	//Render2DBack()
	//Render2DFront()
	Render()
	SetSpriteVisible(bgSpr, 0)
	
	// draw to the shader image
    SetRenderToImage( shaderImage, -1 )
    ClearScreen()
    SetSpritePositionByOffset(whiteSpr, GetPointerX(), GetPointerY())
    SetSpriteVisible(whiteSpr, 1)
    DrawSprite(whiteSpr)
    SetSpriteVisible(whiteSpr, 0)
	SetObjectImage(quad, renderImage, 0)
	SetObjectImage(quad, shaderImage, 1)
	
	// edit shader
	if GetPointerPressed()>0
		//inc shader
		shader = 4
		if shader>4 then shader = 1
		select shader
			case 1 : shaderName$ = "Additive blend" : SetObjectShader(quad, shader1) : endcase
			case 2 : shaderName$ = "Subtractive blend" : SetObjectShader(quad, shader2) : endcase
			case 3 : shaderName$ = "Multiplicative blend" : SetObjectShader(quad, shader3) : endcase
			case 4 : shaderName$ = "Sepia" : SetObjectShader(quad, shader4) : endcase
		endselect
	endif
	
	// render the quad to the screen
	SetRenderToScreen()
	ClearScreen()
	Print("fps: " + str(ScreenFPS(), 0))
	Print("Left click to change shader: " + shaderName$)
	DrawObject( quad )
	//Render2DFront()
	Render()
	Swap()
loop
