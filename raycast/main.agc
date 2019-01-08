// this example should work with AGK V1 and V2

// press and hold the spacebar or the on screen button to turn the collision off
// for the box on top

// create two boxes and place one above the other
CreateObjectBox(1,30,10,30)
SetObjectPosition(1,0,20,0)

CreateObjectBox(2,30,10,30)
SetObjectPosition(2,0,-20,0)

// create and position a green sphere to show the start of the raycast
CreateObjectSphere(3,5,12,12)
SetObjectColor(3,0,255,0,255)
SetObjectCollisionMode(3,0) // turn collision off so it does not interfere with the ray cast
SetObjectPosition(3,0,50,0)

// create and position a red sphere to show the end of the raycast
CreateObjectSphere(4,5,12,12)
SetObjectColor(4,255,0,0,255)
SetObjectCollisionMode(4,0) // turn collision off so it does not interfere with the ray cast
SetObjectPosition(4,0,-50,0)

// create a blue sphere to show where the ray cast hits
CreateObjectSphere(5,5,12,12)
SetObjectCollisionMode(5,0) // turn collision off so it does not interfere with the ray cast
SetObjectColor(5,0,0,255,255)

// create a directional and point light
CreatePointLight(1,-1,-1,0.5,10,255,255,255)

// position and orientate camera
SetCameraPosition(1,0,50,-150)
SetCameraLookAt(1,0,0,30,0)


do

        // press and hold spacebar to turn off the collision for top box
        if GetButtonState(1) = 0
                SetObjectCollisionMode(1,1)
        else
                SetObjectCollisionMode(1,0)
        endif

        // set up raycast from green shere to the red sphere
        old_x# = GetObjectX(3)
        old_y# = GetObjectY(3)
        old_z# = GetObjectZ(3)
        new_x# = GetObjectX(4)
        new_y# = GetObjectY(4)
        new_z# = GetObjectZ(4)

        object_hit = ObjectRayCast(0,old_x#,old_y#,old_z#,new_x#,new_y#,new_z#)

        // if either of the boxes have been hit then position the blue sphere at the collision point
        if object_hit <> 0
                setObjectPosition(5,GetObjectRayCastX(0),GetObjectRayCastY(0),GetObjectRayCastZ(0))
        endif

        sync()

loop
