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
			if is_on_ceiling():
				$Sprite/AnimationPlayer.play("Idle")
		Vector2.DOWN:
			movedir = "down"
			if gravity == Vector2.LEFT:
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = 90
			elif gravity == Vector2.RIGHT:
				$Sprite.flip_h = false
				$Sprite.rotation_degrees = -90
			$Sprite/AnimationPlayer.play("Walking")
		(Vector2.LEFT + Vector2.UP):
			movedir = "up"	
			if gravity == Vector2.LEFT:
				$Sprite.flip_h = false
				$Sprite.rotation_degrees = 90
			elif gravity == Vector2.RIGHT:
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = -90
			$Sprite/AnimationPlayer.play("Walking")
		Vector2.LEFT:
			if not is_on_wall():
				movedir = "left"
				$Sprite.flip_h = false
				$Sprite.rotation_degrees = 0
				$Sprite/AnimationPlayer.play("Walking")
			else:
				$Sprite/AnimationPlayer.play("Idle")
				$Sprite.rotation_degrees = +90
		(Vector2.RIGHT + Vector2.UP):
			movedir = "up"	
			if gravity == Vector2.LEFT:
				$Sprite.flip_h = false
				$Sprite.rotation_degrees = 90
			elif gravity == Vector2.RIGHT:
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = -90
			$Sprite/AnimationPlayer.play("Walking")
		Vector2.RIGHT:
			if not is_on_wall():
				movedir = "right"
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = 0
				$Sprite/AnimationPlayer.play("Walking")
			else:
				$Sprite/AnimationPlayer.play("Idle")
				$Sprite.rotation_degrees = -90
		Vector2.ZERO:
			$Sprite/AnimationPlayer.play("Idle")
			
			
	if is_on_ceiling() and (movedir == "left" or movedir == "right"):
		$Sprite.flip_v = true
		$Sprite.rotation_degrees = 0
	elif is_on_wall(): # and (movedir == "up" or movedir == "down"):
		$Sprite.flip_v = false
	elif is_on_floor() or free_fall:
		$Sprite.flip_v = false
		$Sprite.rotation_degrees = 0
		
			
func control_loop():
	motion.x =  int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	motion.y =  int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) 

func movement_loop():
	
	if free_fall:
		gravity.y += 20
	else:
		gravity.y = 0
	
	if is_on_ceiling():
		free_fall = false
		gravity = Vector2.UP
		if motion.y > 0:
			gravity = Vector2.DOWN
	elif is_on_wall():
		free_fall = false
		if motion.x < 0:
			gravity = Vector2.LEFT
		elif motion.x > 0:
			gravity = Vector2.RIGHT
	elif is_on_floor():
		free_fall = false
		motion.y = 0
		gravity = Vector2.DOWN
	else:
		motion.y = 0
		free_fall = true

	
	move_and_slide(motion * SPEED + gravity, Vector2.UP)
	
	$Ceiling.visible = is_on_ceiling()
	$WallLeft.visible = is_on_wall() and gravity == Vector2.LEFT
	$WallRight.visible = is_on_wall() and gravity == Vector2.RIGHT
	$Floor.visible = is_on_floor()
	

