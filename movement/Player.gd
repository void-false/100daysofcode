extends KinematicBody2D

var movement : Vector2 = Vector2.ZERO

const SPEED : int = 150

func _physics_process(delta: float) -> void:
	control_loop()
	movement_loop(delta)
	
	
func control_loop() -> void:
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
func movement_loop(delta: float) -> void:
	move_and_slide(movement * SPEED)