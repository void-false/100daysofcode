createCacti:
	cacti1a = CreateObjectCapsule(0.5, 1.2, 1)
	SetObjectColor(cacti1a, 58, 224, 49, 255)
	SetObjectPosition(cacti1a, -6, 0.6, 7)
	SetObjectCastShadow(cacti1a, 1)

	cacti1b = CreateObjectCapsule(0.5, 1.2, 1)
	SetObjectColor(cacti1b, 58, 224, 49, 255)
	SetObjectPosition(cacti1b, GetObjectX(cacti1a), GetObjectY(cacti1a)+1, GetObjectZ(cacti1a))
	SetObjectCastShadow(cacti1b, 1)
	
	cacti1c = CreateObjectCapsule(0.3, 0.7, 0)
	SetObjectColor(cacti1c, 58, 224, 49, 255)
	SetObjectPosition(cacti1c, GetObjectX(cacti1a)+0.4, GetObjectY(cacti1a), GetObjectZ(cacti1a))
	SetObjectCastShadow(cacti1c, 1)
	
	cacti1d = CreateObjectCapsule(0.3, 1.1, 1)
	SetObjectColor(cacti1d, 58, 224, 49, 255)
	SetObjectPosition(cacti1d, GetObjectX(cacti1c)+0.25, GetObjectY(cacti1c)+0.45, GetObjectZ(cacti1c))
	SetObjectCastShadow(cacti1d, 1)
	
	cacti1e = CreateObjectCapsule(0.2, 0.7, 0)
	SetObjectColor(cacti1e, 58, 224, 49, 255)
	SetObjectPosition(cacti1e, GetObjectX(cacti1b)-0.25, GetObjectY(cacti1b), GetObjectZ(cacti1b))
	SetObjectCastShadow(cacti1e, 1)
	
	cacti1f = CreateObjectCapsule(0.2, 0.9, 1)
	SetObjectColor(cacti1f, 58, 224, 49, 255)
	SetObjectPosition(cacti1f, GetObjectX(cacti1e)-0.25, GetObjectY(cacti1e)+0.35, GetObjectZ(cacti1e))
	SetObjectCastShadow(cacti1f, 1)
	//--------------------------------------------------------------------------------------------------
	
	cacti2a = CreateObjectCapsule(0.5, 1.2, 1)
	SetObjectColor(cacti2a, 58, 224, 49, 255)
	SetObjectPosition(cacti2a, -9, 0.6, 7)
	SetObjectCastShadow(cacti2a, 1)

	cacti2b = CreateObjectCapsule(0.5, 1.2, 1)
	SetObjectColor(cacti2b, 58, 224, 49, 255)
	SetObjectPosition(cacti2b, GetObjectX(cacti2a), GetObjectY(cacti2a)+1, GetObjectZ(cacti2a))
	SetObjectCastShadow(cacti2b, 1)
	
	cacti2c = CreateObjectCapsule(0.3, 0.7, 0)
	SetObjectColor(cacti2c, 58, 224, 49, 255)
	SetObjectPosition(cacti2c, GetObjectX(cacti2a)+0.4, GetObjectY(cacti2a), GetObjectZ(cacti2a))
	SetObjectCastShadow(cacti2c, 1)
	
	cacti2d = CreateObjectCapsule(0.3, 1.1, 1)
	SetObjectColor(cacti2d, 58, 224, 49, 255)
	SetObjectPosition(cacti2d, GetObjectX(cacti2c)+0.25, GetObjectY(cacti2c)+0.45, GetObjectZ(cacti2c))
	SetObjectCastShadow(cacti2d, 1)
	
	cacti2e = CreateObjectCapsule(0.2, 0.7, 0)
	SetObjectColor(cacti2e, 58, 224, 49, 255)
	SetObjectPosition(cacti2e, GetObjectX(cacti2b)-0.25, GetObjectY(cacti2b), GetObjectZ(cacti2b))
	SetObjectCastShadow(cacti2e, 1)
	
	cacti2f = CreateObjectCapsule(0.2, 0.9, 1)
	SetObjectColor(cacti2f, 58, 224, 49, 255)
	SetObjectPosition(cacti2f, GetObjectX(cacti2e)-0.25, GetObjectY(cacti2e)+0.35, GetObjectZ(cacti2e))
	SetObjectCastShadow(cacti2f, 1)
return
