extends KinematicBody2D

var motion = Vector2()
var speed = 200

func _physics_process(delta):
	control_loop()
	move_loop()
	spritedir_loop()

func control_loop():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

func move_loop():
	move_and_slide(motion.normalized() * speed)

func spritedir_loop():

	if motion.length() > 0:
		$AnimationPlayer.play("Flying")
		$Sprite.flip_h =  motion.x < 0
	else:
		$AnimationPlayer.stop()