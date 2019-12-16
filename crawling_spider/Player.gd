extends KinematicBody2D

onready var web = preload("res://web.tscn")

const JUMP_HEIGHT = -600
const SPEED : int = 200
const ACCEL : int = 130

enum Surface {CEILING, WALL_RIGHT, FLOOR, WALL_LEFT}

var gravity : Vector2 = Vector2.ZERO
var movement : Vector2 = Vector2.ZERO
var movedir = "right"
var free_fall : bool = false
var is_alive = true
var is_dead_anim_playing = false
var prev_surface = null
var current_surface = Surface.FLOOR
var prev_position = Vector2.ZERO
var new_position = Vector2.ZERO

func _physics_process(delta):
	control_loop()
	
	spritedir_loop()
	
	collision_loop()
	
	movement_loop()
	
	#check_collisions_loop()
	
func control_loop():
	if not is_alive:
		return
	if not visible:
		movement = Vector2.ZERO
		return

	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
func collision_loop() -> void:
	
	prev_surface = current_surface
	
	if is_alive:
		free_fall = false
	
	if $NorthLeft.is_colliding() and $WestUp.is_colliding() and not $WestDown.is_colliding():
		if movement.y < 0:
			gravity = Vector2.UP * ACCEL + Vector2.LEFT
		elif movement.x < 0:
			gravity = Vector2.LEFT * ACCEL + Vector2.UP
		else:
			gravity = (Vector2.UP + Vector2.LEFT) * ACCEL
	
	elif $NorthRight.is_colliding() and $EastUp.is_colliding() and not $EastDown.is_colliding():
		if movement.y < 0:
			gravity = Vector2.UP * ACCEL + Vector2.RIGHT
		elif movement.x > 0:
			gravity = Vector2.RIGHT * ACCEL + Vector2.UP
		else:
			gravity = (Vector2.UP + Vector2.RIGHT) * ACCEL

	elif $SouthRight.is_colliding() and $EastDown.is_colliding() and not $SouthLeft.is_colliding():
		if movement.y > 0:
			gravity = Vector2.DOWN * ACCEL + Vector2.RIGHT
		elif movement.x > 0:
			gravity = Vector2.RIGHT * ACCEL + Vector2.DOWN
		else:
			gravity = (Vector2.DOWN + Vector2.RIGHT) * ACCEL

	elif $SouthLeft.is_colliding() and $WestDown.is_colliding() and not $SouthRight.is_colliding():
		if movement.y > 0:
			gravity = Vector2.DOWN  * ACCEL + Vector2.LEFT
		elif movement.x < 0:
			gravity = Vector2.LEFT  * ACCEL + Vector2.DOWN
		else:
			gravity = (Vector2.DOWN + Vector2.LEFT) * ACCEL
	
	
	elif $NorthLeft.is_colliding() or $NorthRight.is_colliding():
		current_surface = Surface.CEILING
		gravity = Vector2.UP * ACCEL
	elif $EastDown.is_colliding() or $EastUp.is_colliding():
		current_surface = Surface.WALL_RIGHT
		gravity = Vector2.RIGHT * ACCEL
	elif $WestUp.is_colliding() or $WestDown.is_colliding():
		current_surface = Surface.WALL_LEFT
		gravity = Vector2.LEFT * ACCEL
	elif $SouthRight.is_colliding() or $SouthLeft.is_colliding():
		current_surface = Surface.FLOOR
		gravity = Vector2.DOWN * ACCEL
		movement.y = clamp(movement.y, 0, 1)
	else:
		free_fall = true
		current_surface = null
		
	if free_fall:
		gravity.x = 0
		gravity.y = abs(gravity.y) + 20
		movement.y = 0

func movement_loop() -> void:
	
	prev_position = position.round()

	if free_fall or not is_on_wall():
		move_and_slide(movement * SPEED + gravity)
	elif movement.length() > 0:
		move_and_slide(movement * SPEED + gravity)

	new_position = position.round()
	
func spritedir_loop() -> void:
	if not is_alive:
		if not is_dead_anim_playing:
			$Sprite/AnimationPlayer.play("Dead")
			is_dead_anim_playing = true
			movement = Vector2.ZERO
		return
	
	if prev_position != new_position:
		$Sprite/AnimationPlayer.play("Walking")
	else:
		$Sprite/AnimationPlayer.play("Idle")
		
	match current_surface:
		Surface.CEILING:
			$Sprite.rotation_degrees = 0
			$Sprite.flip_v = true
			if movement.x < 0.0:
				$Sprite.flip_h = false
			elif movement.x > 0.0:
				$Sprite.flip_h = true
			elif movement.y < 0:
				if prev_surface == Surface.WALL_LEFT:
					$Sprite.flip_h = true
				elif prev_surface == Surface.WALL_RIGHT:
					$Sprite.flip_h = false
		Surface.WALL_LEFT:
			$Sprite.flip_v = false
			$Sprite.rotation_degrees = 90
			if movement.y < 0.0:
				$Sprite.flip_h = false
			elif movement.y > 0.0:
				$Sprite.flip_h = true
		Surface.FLOOR:
			$Sprite.rotation_degrees = 0
			$Sprite.flip_v = false
			if movement.x < 0.0:
				$Sprite.flip_h = false
			elif movement.x > 0.0:
				$Sprite.flip_h = true
		Surface.WALL_RIGHT:
			$Sprite.flip_v = false
			$Sprite.rotation_degrees = -90
			if movement.y < 0.0:
				$Sprite.flip_h = true
			elif movement.y > 0.0:
				$Sprite.flip_h = false
	
	if free_fall:
		$Sprite/AnimationPlayer.play("Idle")
		$Sprite.rotation_degrees = 0
		$Sprite.flip_v = false
		if movement.x < 0:
			$Sprite.flip_h = false
		if movement.x > 0:
			$Sprite.flip_h = true
#		
#	if is_on_ceiling(): # and (movedir == "left" or movedir == "right"):
#		if previous_plane == "wall_left":
#			$Sprite.flip_h = true
#		elif previous_plane == "wall_right":
#			$Sprite.flip_h = false
#		$Sprite.flip_v = true
#		$Sprite.rotation_degrees = 0
#	elif is_on_wall(): # and (movedir == "up" or movedir == "down"):
#		$Sprite.flip_v = false
#		if previous_plane == "ceiling":
#			if movement.x > 0:
#				$Sprite.flip_h = false
#			elif movement.x < 0:
#				$Sprite.flip_h = true
#	elif is_on_floor() or free_fall:
#		$Sprite.flip_v = false
#		$Sprite.rotation_degrees = 0
	
func get_prev_surface():
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
	
	
