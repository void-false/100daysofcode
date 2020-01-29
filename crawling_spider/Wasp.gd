extends KinematicBody2D

var motion = Vector2.RIGHT
var speed = 200
signal hit_player

func _physics_process(delta):
	# control_loop()
	move_loop()
	spritedir_loop()

func control_loop():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

func move_loop():
	
	move_and_slide(motion.normalized() * speed)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			emit_signal("hit_player")
			motion.x *= -1
			return
	if is_on_wall():
		motion.x *= -1

func spritedir_loop():

	if motion.length() > 0:
		$AnimationPlayer.playback_speed = 3
		$Sprite.flip_h =  motion.x > 0
	else:
		$AnimationPlayer.playback_speed = 1
