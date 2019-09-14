extends KinematicBody2D

const GRAVITY = 20
const JUMP_HEIGHT = -400
const UP = Vector2(0, -1)

var motion = Vector2()

func _physics_process(delta):
	
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		motion.x = -200
		$Sprite.flip_h = false
		$Sprite/AnimationPlayer.play("Walking")
	elif Input.is_action_pressed("ui_right"):
		motion.x = 200
		$Sprite.flip_h = true
		$Sprite/AnimationPlayer.play("Walking")
	else:
		motion.x = 0
		$Sprite/AnimationPlayer.play("Idle")
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		
	motion = move_and_slide(motion, UP)