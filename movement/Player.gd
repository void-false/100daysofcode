extends KinematicBody2D

var movement : Vector2 = Vector2.ZERO
onready var raycast_list : Array = [$NorthLeft, $NorthRight, $EastUp, $EastDown, $SouthLeft, $SouthRight, $WestUp, $WestDown]
var free_fall : bool = false
var gravity : Vector2 = Vector2.DOWN

const SPEED : int = 150

func _physics_process(delta: float) -> void:
	control_loop()
	movement_loop(delta)
	collision_loop()
	print(gravity)
		
func control_loop() -> void:
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
func movement_loop(delta: float) -> void:
	move_and_slide(movement * SPEED + gravity)
	
func collision_loop() -> void:
	free_fall = true
	for raycast in raycast_list:
		if raycast.is_colliding(): 
			free_fall = false
	if free_fall:
		movement.y = 0
		gravity.x = 0
		gravity.y += 10
	else:
		if $NorthLeft.is_colliding() or $NorthRight.is_colliding(): # ceiling
			gravity = Vector2.UP
		elif $EastDown.is_colliding() or $EastUp.is_colliding(): # right wall
			gravity = Vector2.RIGHT
		elif $SouthLeft.is_colliding() or $SouthRight.is_colliding(): # floor
			gravity = Vector2.DOWN
		elif $WestDown.is_colliding() or $WestUp.is_colliding(): # left wall
			gravity = Vector2.LEFT