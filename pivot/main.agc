
// Project: pivot 
// Created: 2019-01-17

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "pivot" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

// these are to show where world 0,0,0 is
ObjectVertical = CreateObjectBox(.1,100,.1)
SetObjectColor(ObjectVertical,255,0,0,255)
ObjectHorizontal = CreateObjectBox(100,.1,.1)
SetObjectColor(ObjectHorizontal,255,0,0,255)

// this object keeps its pivot point at
// its local 0,0,0 (center of the object)
// much like your head pivots around its center
ObjectOne = CreateObjectBox(3,3,3)
SetObjectPosition(ObjectOne,0,3,0)

// this object will have its local center at
// the worlds 0,0,0 point (the sphere)
// much like your arm pivots on your shoulder
ObjectTwo = CreateObjectBox(6,1,1)
SetObjectPosition(ObjectTwo,-3,0,0)
FixObjectPivot(ObjectTwo)
SetObjectPosition(ObjectTwo, 5, 6, 3)

do  
        // rotate each object around its local center
    RotateOBjectLocalY(ObjectOne,.5)
    RotateObjectLocalY(ObjectTwo,.5)

    Sync()
loop
