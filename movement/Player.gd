extends KinematicBody2D

var movement : Vector2 = Vector2.ZERO
onready var raycast_list : Array = [$NorthLeft, $NorthRight, $EastUp, $EastDown, $SouthLeft, $SouthRight, $WestUp, $WestDown]
var free_fall : bool = false
var gravity : Vector2 = Vector2.DOWN

const SPEED : int = 150

func _physics_process(delta: float) -> void:
	control_loop()
	collision_loop()
	movement_loop(delta)
		
func control_loop() -> void:
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
func collision_loop() -> void:
	free_fall = true
	for raycast in raycast_list:
		if raycast.is_colliding(): 
			free_fall = false
			break
	if free_fall:
		movement.y = 0
		gravity.x = 0
		gravity.y += 10
	else:
		if $NorthLeft.is_colliding() or $NorthRight.is_colliding(): # ceiling
			gravity = Vector2.UP
		elif $EastDown.is_colliding() or $EastUp.is_colliding(): # right wall
			gravity = Vector2.RIGHT
		elif $WestDown.is_colliding() or $WestUp.is_colliding(): # left wall
			gravity = Vector2.LEFT
		elif $SouthLeft.is_colliding() or $SouthRight.is_colliding(): # floor
			gravity = Vector2.DOWN
			movement.y = clamp(movement.y, 0, 1)
			
func movement_loop(delta: float) -> void:
	if not movement and gravity.length() < 5:
		pass
	else:
		move_and_slide(movement * SPEED + gravity)
