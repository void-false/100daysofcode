
ground = CreateObjectBox(100, 0, 100)
SetObjectColor(ground, 244, 194, 44, 255)
Create3DPhysicsKinematicBody(ground)
SetObjectCastShadow(ground, 1)
SetObjectReceiveShadow(ground, 1)
SetObjectLightMode(ground, 1)
SetObject3DPhysicsFriction(ground, 1)
SetObject3DPhysicsRollingFriction(ground, 1)
	
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

bullet = CreateObjectBox(0.022, 0.022, 0.022)
SetObjectColor(bullet, 119, 27, 12, 255)
SetObjectPosition(bullet, 0, 1.2, 0)
SetObjectCollisionMode(bullet, 0)
SetObjectVisible(bullet, 0)


pointer = CreateObjectBox(0.001, 0.001, 1.0)
SetObjectCollisionMode(pointer, 0)
SetObjectColor(pointer, 200, 0, 0, 255)
SetObjectPosition(pointer, 0, 0, 0.5)
FixObjectPivot(pointer)

pointB = CreateObjectSphere(0.01, 5, 5)
SetObjectColor(pointB, 0, 0, 255, 255)
SetObjectVisible(pointB, 0)

saloonFloor = CreateObjectBox(10, 0.3, 1)
SetObjectColor(saloonFloor,76,0,11, 255)
SetObjectPosition(saloonFloor, 0, 0.15, 10)
Create3DPhysicsStaticBody(saloonFloor)
SetObjectCastShadow(saloonFloor, 1)

saloonLeftBottom = CreateObjectBox(4.0, 0.7, 1)
SetObjectColor(saloonLeftBottom,136,0,21, 255)
SetObjectPosition(saloonLeftBottom, GetObjectX(saloonFloor)-3, GetObjectY(saloonFloor)+0.45, GetObjectZ(saloonFloor)+0.01)
Create3DPhysicsStaticBody(saloonLeftBottom)
SetObjectCastShadow(saloonLeftBottom, 1)

saloonRightBottom = CreateObjectBox(4.0, 0.7, 1)
SetObjectColor(saloonRightBottom,136,0,21, 255)
SetObjectPosition(saloonRightBottom, GetObjectX(saloonFloor)+3, GetObjectY(saloonFloor)+0.45, GetObjectZ(saloonFloor)+0.01)
Create3DPhysicsStaticBody(saloonRightBottom)
SetObjectCastShadow(saloonRightBottom, 1)

saloonMiddle = CreateObjectBox(10, 0.3, 1)
SetObjectColor(saloonMiddle,136,0,21, 255)
SetObjectPosition(saloonMiddle,  GetObjectX(saloonFloor), GetObjectY(saloonFloor)+3.7, GetObjectZ(saloonFloor))
Create3DPhysicsStaticBody(saloonMiddle)
SetObjectCastShadow(saloonMiddle, 1)

saloonTop = CreateObjectBox(10, 0.3, 1)
SetObjectColor(saloonTop,136,0,21, 255)
SetObjectPosition(saloonTop,  GetObjectX(saloonFloor), GetObjectY(saloonFloor)+7, GetObjectZ(saloonFloor))
Create3DPhysicsStaticBody(saloonTop)
SetObjectCastShadow(saloonTop, 1)

saloonLeft = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonLeft,255,165,79, 255)
SetObjectPosition(saloonLeft,  GetObjectX(saloonFloor)-4.5, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonLeft)
SetObjectCastShadow(saloonLeft, 1)

saloonRight = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonRight,255,165,79, 255)
SetObjectPosition(saloonRight,  GetObjectX(saloonFloor)+4.5, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonRight)
SetObjectCastShadow(saloonRight, 1)

saloonColumnLeft = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonColumnLeft,255,165,79, 255)
SetObjectPosition(saloonColumnLeft,  GetObjectX(saloonFloor)-1.51, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonColumnLeft)
SetObjectCastShadow(saloonColumnLeft, 1)

saloonColumnRight = CreateObjectBox(1, 7, 1)
SetObjectColor(saloonColumnRight,255,165,79, 255)
SetObjectPosition(saloonColumnRight,  GetObjectX(saloonFloor)+1.51, GetObjectY(saloonFloor)+3.5, GetObjectZ(saloonFloor)+0.1)
Create3DPhysicsStaticBody(saloonColumnRight)
SetObjectCastShadow(saloonColumnRight, 1)

gameOver = CreateObjectPlane(0.5, 0.25)
SetObjectCollisionMode(gameOver, 0)
gameOverImg = LoadImage("gameover.png")
SetObjectTransparency(gameOver, 1)
//SetImageTransparentColor(gameOverImg, 0, 0, 0)
SetObjectImage(gameOver, gameOverImg, 0)
SetObjectVisible(gameOver, 0)

quad as integer
quad = CreateObjectQuad()

mainMenu = CreateObjectPlane(1.6, 0.9)
SetObjectTransparency(mainMenu, 1)
SetObjectColor(mainMenu, 244, 113, 66, 125)
SetObjectPosition(mainMenu, 0, 1.45, 1.5)
SetObjectLightMode(mainMenu, 1)
SetObjectCastShadow(mainMenu, 1)
SetObjectReceiveShadow(mainMenu, 1)

buttonPlay = CreateObjectPlane(0.32, 0.09)
SetObjectColor(buttonPlay, 244, 227, 73, 255)
SetObjectPosition(buttonPlay, 0, 1.7, 1.45)
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

menuObject as integer[]
menuObject.insert(mainMenu)
menuObject.insert(buttonPlay)
menuObject.insert(buttonHelp)
menuObject.insert(buttonExit)
