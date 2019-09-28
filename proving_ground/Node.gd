extends Node

var direction = Vector2()


func _physics_process(delta):
	direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	print(direction)
