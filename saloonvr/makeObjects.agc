
ground = CreateObjectBox(100, 0, 100)
SetObjectColor(ground, 244, 194, 44, 255)
Create3DPhysicsKinematicBody(ground)
SetObjectCastShadow(ground, 1)
SetObjectReceiveShadow(ground, 1)
SetObjectLightMode(ground, 1)
SetObject3DPhysicsFriction(ground, 1)
SetObject3DPhysicsRollingFriction(ground, 1)
	
global gun as integer
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
SetObjectVisible(bullet, 0)


saloonFloor = CreateObjectBox(10, 0.3, 1)
SetObjectColor(saloonFloor,76,0,11, 255)
SetObjectPosition(saloonFloor, 0, 0.15, 10)
Create3DPhysicsStaticBody(saloonFloor)

saloonLeftBottom = CreateObjectBox(4.0, 0.7, 1)
SetObjectColor(saloonLeftBottom,136,0,21, 255)
SetObjectPosition(saloonLeftBottom, GetObjectX(saloonFloor)-3, GetObjectY(saloonFloor)+0.45, GetObjectZ(saloonFloor)+0.01)
Create3DPhysicsStaticBody(saloonLeftBottom)

saloonRightBottom = CreateObjectBox(4.0, 0.7, 1)
SetObjectColor(saloonRightBottom,136,0,21, 255)
SetObjectPosition(saloonRightBottom, GetObjectX(saloonFloor)+3, GetObjectY(saloonFloor)+0.45, GetObjectZ(saloonFloor)+0.01)
Create3DPhysicsStaticBody(saloonRightBottom)

saloonMiddle = CreateObjectBox(10, 0.3, 1)
SetObjectColor(saloonMiddle,136,0,21, 255)
SetObjectPosition(saloonMiddle,  GetObjectX(saloonFloor), GetObjectY(saloonFloor)+3.7, GetObjectZ(saloonFloor))
Create3DPhysicsStaticBody(saloonMiddle)

saloonTop = CreateObjectBox(10, 0.3, 1)
SetObjectColor(saloonTop,136,0,21, 255)
SetObjectPosition(saloonTop,  GetObjectX(saloonFloor), GetObjectY(saloonFloor)+7, GetObjectZ(saloonFloor))
Create3DPhysicsStaticBody(saloonTop)

saloonLeft = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonLeft,255,165,79, 255)
SetObjectPosition(saloonLeft,  GetObjectX(saloonFloor)-4.5, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonLeft)

saloonRight = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonRight,255,165,79, 255)
SetObjectPosition(saloonRight,  GetObjectX(saloonFloor)+4.5, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonRight)

saloonColumnLeft = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonColumnLeft,255,165,79, 255)
SetObjectPosition(saloonColumnLeft,  GetObjectX(saloonFloor)-1.51, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonColumnLeft)

saloonColumnRight = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonColumnRight,255,165,79, 255)
SetObjectPosition(saloonColumnRight,  GetObjectX(saloonFloor)+1.51, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonColumnRight)

