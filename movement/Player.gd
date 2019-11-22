extends KinematicBody2D

var movement : Vector2 = Vector2.ZERO
onready var raycast_list : Array = [$NorthLeft, $NorthRight, $EastUp, $EastDown, $SouthLeft, $SouthRight, $WestUp, $WestDown]
var free_fall : bool = false
var gravity : Vector2 = Vector2.ZERO

const SPEED : int = 200
const  ACCEL : int = 130

func _physics_process(delta: float) -> void:
	control_loop()
	collision_loop()
	movement_loop(delta)
		
func control_loop() -> void:
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
func collision_loop() -> void:
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
		gravity = Vector2.UP * ACCEL
	elif $EastDown.is_colliding() or $EastUp.is_colliding():
		gravity = Vector2.RIGHT * ACCEL
	elif $WestUp.is_colliding() or $WestDown.is_colliding():
		gravity = Vector2.LEFT * ACCEL
	elif $SouthRight.is_colliding() or $SouthLeft.is_colliding():
		gravity = Vector2.DOWN * ACCEL
		movement.y = clamp(movement.y, 0, 1)
	else:
		free_fall = true
		
	if free_fall:
		gravity.x = 0
		gravity.y = abs(gravity.y) + 20
		movement.y = 0

func movement_loop(delta: float) -> void:

	if free_fall or not is_on_wall():
		move_and_slide(movement * SPEED + gravity)
	elif movement.length() > 0:
		move_and_slide(movement * SPEED + gravity)

