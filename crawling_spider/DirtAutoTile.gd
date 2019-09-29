extends Node

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()
		#get_tree().quit()

