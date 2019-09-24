extends KinematicBody2D

const JUMP_HEIGHT = -600
const SPEED = 150

var gravity = Vector2.UP
var motion = Vector2()
var movedir = "right"
var walking_on_ceiling = false
var walking_on_wall = false
var free_fall = false

func _physics_process(delta):
	control_loop()
	movement_loop()
	spritedir_loop()
	
func spritedir_loop():
	match motion:
		Vector2.UP:
			movedir = "up"	
			if gravity == Vector2.LEFT:
				$Sprite.flip_h = false
				$Sprite.rotation_degrees = 90
			elif gravity == Vector2.RIGHT:
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = -90
			$Sprite/AnimationPlayer.play("Walking")
		Vector2.DOWN:
			movedir = "down"
			if gravity == Vector2.LEFT:
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = 90
			elif gravity == Vector2.RIGHT:
				$Sprite.flip_h = false
				$Sprite.rotation_degrees = -90
			$Sprite/AnimationPlayer.play("Walking")
		Vector2.LEFT:
			movedir = "left"
			$Sprite.flip_h = false
			$Sprite.rotation_degrees = 0
			$Sprite/AnimationPlayer.play("Walking")
		Vector2.RIGHT:
			movedir = "right"
			$Sprite.flip_h = true
			$Sprite.rotation_degrees = 0
			$Sprite/AnimationPlayer.play("Walking")
		Vector2.ZERO:
			$Sprite/AnimationPlayer.play("Idle")
			
	if is_on_ceiling() and (movedir == "left" or movedir == "right"):
		$Sprite.flip_v = true
		$Sprite.rotation_degrees = 0
	elif is_on_wall() and (movedir == "up" or movedir == "down"):
		$Sprite.flip_v = false
	elif is_on_floor():
		$Sprite.flip_v = false

		
			
func control_loop():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")

	motion.x = -int(LEFT) + int(RIGHT)
	motion.y = -int(UP) + int(DOWN)

func movement_loop():
	
	if free_fall:
		gravity.y += 20
	else:
		gravity.y = 0
	
	if is_on_ceiling():
		free_fall = false
		gravity = Vector2.UP
		if movedir == "down":
			gravity = Vector2.DOWN
	elif is_on_wall():
		free_fall = false
		if movedir == "left":
			gravity = Vector2.LEFT
		elif movedir == "right":
			gravity = Vector2.RIGHT
	elif is_on_floor():
		free_fall = false
		motion.y = 0
		gravity = Vector2.DOWN
	else:
		motion.y = 0
		free_fall = true

	
	move_and_slide(motion.normalized() * SPEED + gravity, Vector2.UP)
	
	$Ceiling.visible = is_on_ceiling()
	$WallLeft.visible = is_on_wall()  
	$WallRight.visible = is_on_wall() 
	$Floor.visible = is_on_floor()
	

