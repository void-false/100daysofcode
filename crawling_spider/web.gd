extends KinematicBody2D

var speed : int = 400
var webdir : Vector2 = Vector2.ZERO 

func _physics_process(delta: float) -> void:
	var collide_object : KinematicCollision2D = move_and_collide(Vector2(speed * delta * webdir.x, speed * delta * webdir.y))
	if collide_object:
		collide_object.collider.queue_free()
		queue_free()