extends KinematicBody2D

var motion = Vector2.RIGHT
var speed = 200

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
	if test_move(transform, motion):
		motion.x *= -1
	move_and_slide(motion.normalized() * speed)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.collider.name)


func spritedir_loop():

	if motion.length() > 0:
		$AnimationPlayer.seek(0.3, false)
		$AnimationPlayer.playback_speed = 3
		$Sprite.flip_h =  motion.x > 0
	else:
		$AnimationPlayer.playback_speed = 1