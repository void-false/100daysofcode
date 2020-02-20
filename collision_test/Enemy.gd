extends KinematicBody2D


var dir: int = 1
var speed: int = 100
var movement: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	if is_on_wall():
		dir *= -1
	movement = Vector2(speed * dir, 0)
	move_and_slide(movement, Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision and collision.collider.name == "Player":
			print("HIT", randi())
			return


#func move_loop():
#
#	move_and_slide(motion.normalized() * speed)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.name == "Player":
#			emit_signal("hit_player")
#			motion.x *= -1
#			return
#	if is_on_wall():
#		motion.x *= -1
