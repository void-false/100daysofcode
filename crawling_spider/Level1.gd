extends Node

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()
		
	elif Input.is_action_pressed("quit"):
		get_tree().quit()



func _on_BackToMenuTimer_timeout() -> void:
	get_tree().change_scene("res://MainMenu.tscn")