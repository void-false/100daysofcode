

// Project: Move3D 
// Created: 2018-02-17

 // BY BenGismo, modified by Blendman, thanks to PartTimeCoder for help
 
 
// set window properties
SetWindowTitle( "Move Object 3D with mouse" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window
 
// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 0, 0, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetPrintSize(20)
SetAntialiasMode(1)
	
FoldStart // Constant , global 
	
#CONSTANT KEY_SHIFT        16		
#CONSTANT KEY_CONTROL      17
#CONSTANT KEY_ALT      	   18


Global Alt, ObjX, ObjY, ObjZ, MovingObject as integer
global startx#
global starty#
global angx#
global angy#

global speed# = 4
global StX#
global StY#
global StZ#
 
Foldend
 
 
// Set camera variables
SetCameraPosition(1, -60, 60, -60)
SetCameraLookAt( 1, 0,0,0,0 )
SetCamerarange(1,1,10000)
SetCameraFov(1, 70)
 
//create the box
global box
box = CreateObjectBox(10,10,10)
SetObjectPosition(box,0,5,0)
SetObjectColor(box, 200,50,50,255)
 
//create the plane
global plane
plane = CreateObjectPlane(1000,1000)
SetObjectRotation(plane,90,0,0)
SetObjectColor(plane, 100,100,120,255)

 
 
 
do
   
    MoveCam()
    MoveBox()
 
    Print("Press Middle Mouse to rotate camera")
    Print("Press Left Mouse on the box to move the box")
    Print("Use Arrow keys to move the camera around")
    Print("Box position : "+str(GetObjectX(box),0)+"/"+str(GetObjectY(box),0)+"/"+str(GetObjectZ(box),0))
    
    Sync()
    
loop
 
 
 
 
Function MoveCam()
     
     
    // move the camera
    if ( GetRawKeyState( 38 ) ) then MoveCameraLocalZ( 1, speed# )      
    if ( GetRawKeyState( 40 ) ) then MoveCameraLocalZ( 1, -speed# )     
 
    if ( GetRawKeyState( 37) ) then MoveCameraLocalX( 1, -speed# )
    if ( GetRawKeyState( 39 ) ) then MoveCameraLocalX( 1, speed# )
 
    if ( GetRawKeyState( 81 ) ) then MoveCameraLocalY( 1, -speed# )
    if ( GetRawKeyState( 69 ) ) then MoveCameraLocalY( 1, speed# )
    
   
     
    // rotate the camera
    if ( GetRawMouseMiddlePressed() )
        startx# = GetPointerX()
        starty# = GetPointerY()
        angx# = GetCameraAngleX(1)
        angy# = GetCameraAngleY(1)
        pressed = 1
    endif
 
    if ( GetRawMouseMiddleState() = 1 )
        fDiffX# = (GetPointerX() - startx#)/4.0
        fDiffY# = (GetPointerY() - starty#)/4.0
 
        newX# = angx# + fDiffY#
        if ( newX# > 89 ) then newX# = 89
        if ( newX# < -89 ) then newX# = -89
        SetCameraRotation( 1, newX#, angy# + fDiffX#, 0 )
        
    endif
     
     
endfunction
 
 
Function MoveBox()
     
    
     
    // Check if the left mouse was pressed
    
    if ( GetRawMouseLeftPressed() )
		
        mousex# = GetPointerX()
        mousey# = GetPointerY()
         
        // Get 3D vector of where we clicked
        VecX# = Get3DVectorXFromScreen( mousex#, mousey# ) *1000
        VecY# = Get3DVectorYFromScreen( mousex#, mousey# ) *1000
        VecZ# = Get3DVectorZFromScreen( mousex#, mousey# ) *1000
         
        CamX# = GetCameraX(1)
        CamY# = GetCameraY(1)
        CamZ# = GetCameraZ(1)
        
        SetObjectColorEmissive(box, 0,0,0)
         
        // Check if the box was selected
        if( ObjectRayCast( box ,CamX#,CamY#,CamZ#,CamX#+VecX#,CamY#+VecY#,CamZ#+VecZ#))
            MovingObject = 1
            SetObjectColorEmissive(box, 255,0,0)
        else
            MovingObject = 0
        endif
		
		objx = GetObjectX(box)
		objy = GetObjectY(box)
		objz = GetObjectZ(box)
		
    endif
     
    if ( GetRawMouseLeftState() and MovingObject=1 )
        
        mousex# = GetPointerX()
        mousey# = GetPointerY()
         
        CamX# = GetCameraX(1)
        CamY# = GetCameraY(1)
        CamZ# = GetCameraZ(1)
         
        // MoveObject
        u =  GetDistance3D(camx#, camY#, camZ#, objx, objy, objz) // 100
        Print("Distance Camera to box:  "+str(u))
        VecX# = Get3DVectorXFromScreen( mousex#, mousey# ) * u + GetCameraX(1) 
        VecY# = Get3DVectorYFromScreen( mousex#, mousey# ) * u + GetCameraY(1) 
        VecZ# = Get3DVectorZFromScreen( mousex#, mousey# ) * u + GetCameraZ(1) 

        SetObjectPosition(box, VecX#, VecY#, VecZ#)
        
        
    endif
         
endfunction


function GetDistance3D(x1#,y1#,z1#,x2#,y2#,z2#)
	
	dx#=x1#-x2#
	dy#=y1#-y2#
	dz#=z1#-z2#
	distance# = sqrt(dx#*dx# + dy#*dy# + dz#*dz#)
	
endfunction distance#

