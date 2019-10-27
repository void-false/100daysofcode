extends KinematicBody2D

const JUMP_HEIGHT = -600
const SPEED = 150

var gravity = Vector2.UP
var motion = Vector2()
var movedir = "right"
var free_fall = false
var previous_plane
var is_alive = true
var is_dead_anim_playing = false
var is_grabbing : bool = false
var boost : int = 2

func _physics_process(delta):
	control_loop()
	movement_loop()
	spritedir_loop()
	check_collisions_loop()
	
func spritedir_loop():
	if not is_alive:
		if not is_dead_anim_playing:
			$Sprite/AnimationPlayer.play("Dead")
			is_dead_anim_playing = true
			motion = Vector2.ZERO
		return
	
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
			elif gravity == Vector2.UP:
				$Sprite.flip_h = false
			$Sprite/AnimationPlayer.play("Walking")
		(Vector2.LEFT + Vector2.DOWN):
			movedir = "down"
			if gravity == Vector2.LEFT:
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = 90
			elif gravity == Vector2.RIGHT:
				$Sprite.flip_h = false
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
			elif gravity == Vector2.UP:
				$Sprite.flip_h = true
			$Sprite/AnimationPlayer.play("Walking")
		(Vector2.RIGHT + Vector2.DOWN):
			movedir = "down"
			if gravity == Vector2.LEFT:
				$Sprite.flip_h = true
				$Sprite.rotation_degrees = 90
			elif gravity == Vector2.RIGHT:
				$Sprite.flip_h = false
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
			
			
	if is_on_ceiling(): # and (movedir == "left" or movedir == "right"):
		if previous_plane == "wall_left":
			$Sprite.flip_h = true
		elif previous_plane == "wall_right":
			$Sprite.flip_h = false
		$Sprite.flip_v = true
		$Sprite.rotation_degrees = 0
	elif is_on_wall(): # and (movedir == "up" or movedir == "down"):
		$Sprite.flip_v = false
		if previous_plane == "ceiling":
			if motion.x > 0:
				$Sprite.flip_h = false
			elif motion.x < 0:
				$Sprite.flip_h = true
	elif is_on_floor() or free_fall:
		$Sprite.flip_v = false
		$Sprite.rotation_degrees = 0
		
			
func control_loop():
	if not is_alive:
		return
	if not visible:
		motion = Vector2.ZERO
		return

	is_grabbing = Input.is_action_pressed("grab")

	motion.x =  Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")


func movement_loop() -> void:
	
	if free_fall:
		gravity.y += 20
	
	if is_on_ceiling() and is_alive:
		free_fall = false
		gravity = Vector2.UP
		if is_grabbing:
			motion.y = clamp(motion.y, -1, 0)
	elif is_on_wall():
		free_fall = false
		if test_move(transform, Vector2.LEFT):
			gravity = Vector2.LEFT
			if is_grabbing:
				motion.x = clamp(motion.x, -1, 0)
		elif test_move(transform, Vector2.RIGHT):
			gravity = Vector2.RIGHT
			if is_grabbing:
				motion.x = clamp(motion.x, 0, 1)
	elif is_on_floor():
		free_fall = false
		motion.y = 0
		gravity = Vector2.DOWN
	else:
		motion.y = 0
		free_fall = true
	
	if free_fall and previous_plane == "wall_right" and motion.x == 0:
		motion.x = boost
	elif free_fall and previous_plane == "wall_left" and motion.x == 0:
		motion.x = -boost
			
			
	if is_grabbing and free_fall and previous_plane == "ceiling":
		gravity = Vector2(0, -40)
		motion.x = -motion.x
		print("HERE")
		
	previous_plane = get_previous_plane()

	if not is_alive:
		free_fall = true

	move_and_slide(motion * SPEED + gravity, Vector2.UP)

#	$Ceiling.visible = is_on_ceiling()
#	$WallLeft.visible = is_on_wall() and gravity == Vector2.LEFT
#	$WallRight.visible = is_on_wall() and gravity == Vector2.RIGHT
#	$Floor.visible = is_on_floor()
	$Grabbing.visible = is_grabbing
	
	
func get_previous_plane():
	if is_on_ceiling():
		return "ceiling"
	elif is_on_floor():
		return "floor"
	elif is_on_wall() and gravity == Vector2.RIGHT:
		return "wall_right"
	elif is_on_wall() and gravity == Vector2.LEFT:
		return "wall_left"
	return "none"
	
	
func check_collisions_loop():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Wasp":
			_on_Wasp_hit_player()

func _on_Wasp_hit_player():
	$"../BackToMenuTimer".start()
	is_alive = false
	$Camera2D.current = false
	$CollisionShape2D.disabled = true
	

func _on_ExitDoor_body_entered(body):
	$"../HighScoreTimer".start()
	self.visible = false
	$"../CanvasLayer/WinLabel".visible = true
	$"../CanvasLayer/Fireworks1".emitting = true
	$"../CanvasLayer/Fireworks2".emitting = true
	Globals.end_time = OS.get_ticks_msec()
	